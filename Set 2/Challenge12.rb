#!/usr/bin/ruby

# Set 2 - Challenge 12
# Byte at a time ECB Decrypt (Simple)

require './set2Lib.rb'

consistentKey = randomAESKey16

magicStr = "Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkgaGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBqdXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUgYnkK".unpack('m').join

blockSize = discoverBlockSize(magicStr, consistentKey)
ct = consistentEncryptionOracle('A'*(blockSize*20)+magicStr, consistentKey)
typeOfCipher = detectCipher(ct, blockSize)

# Here is how the attack works:
#
# Assume we have a block size of 5 and a plain text block begins with "Sup"
# First we add BLOCKSIZE-1 constant characters: AAAA
# We end up with this string: AAAASup
# Now we send this string to the oracle which will chop up and pad the string 
# accordingly: AAAAS up\x03\x03\x03
# Throw away the rest and we now have the encryption of AAAAS thanks to the oracle.
#
# Now we don't know that the plain text was "Sup", but we do know that we can iterate 
# for all values starting with AAAA*.  We pass these to the oracle where we match
# up the values.  Now we do this again:
#
# Add BLOCKSIZE-2 constant characters: AAA
# End up with string: AAASup
# Oracle will chop and pad into AAASu p\x04\x04\x04\x04
# We now have the encryption for AAASu
#
# We know that the first byte is S because of our previous attack.  So we cycle through 
# all values starting with AAAS* to the oracle.  When we have a match we know we found the
# next byte.  Repeat until we finish up the block.  Then apply to all blocks of the message.

puts attackECBCipher(magicStr, consistentKey)