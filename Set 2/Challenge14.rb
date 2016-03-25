#!/usr/bin/ruby

# Set 2 - Challenge 14
# Byte at a time ECB Decrypt (Harder)

require './set2Lib.rb'

consistentKey = randomAESKey16
randomPrependStr = randomPrepend

magicStr = "Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkgaGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBqdXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUgYnkK".unpack('m0').join

blockSize = discoverBlockSize(magicStr, consistentKey)

attackerInput = "A"

blockSize = discoverBlockSize(magicStr, consistentKey)

# We pad until the first three blocks register with the "typeOfCipher" function

loop do
	ct = consistentEncryptionOracle(randomPrependStr+attackerInput+magicStr, consistentKey)
	typeOfCipher = detectCipher(ct, blockSize)
	break if typeOfCipher == 'ECB'
	attackerInput.concat("A")
end


puts attackECBCipherPrepend(magicStr, consistentKey, attackerInput, randomPrependStr)