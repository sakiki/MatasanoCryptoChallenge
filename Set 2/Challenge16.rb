#!/usr/bin/ruby

# Set 2 - Challenge 16
# CBC Bitflipping attacks

require './set2Lib.rb'

consistentKey = randomAESKey16
consistentIV = randomAESKey16

blockSize = 16
blockSizeHex = blockSize*2

# Here is the logic:
# Since CBC mode uses the previous cipher text bit with the current decryption
# XOR we can modify the plain text.  The plain text can be thought of as:
# 
# PLAINTEXT = DECRYPTED_CIPHERTEXT XOR CIPHERTEXT(N-1)
# 
# Where DECRYPTED_CIPHERTEXT is the intermediate step after decryption and
# CIPHERTEXT(N-1) is the cipher text of the previous block.  Since we know
# that the PLAINTEXT will be what we specify in the attack string, and we
# know the CIPHERTEXT(N-1) we can attack with bitflipping.
# 
# To "null out" the intermediate step, we realize that:
# 
# DECRYPTED_CIPHERTEXT = PLAINTEXT XOR CIPHERTEXT(N-1)
# 
# Therefore:
# 
# DECRYPTED_CIPHERTEXT XOR PLAINTEXT XOR CIPHERTEXT(N-1) = 0
# 
# If we XOR our wanted value we can then complete the bitflipping attack.
# 
# CIPHERTEXT(N-1)_NEW = CIPHERTEXT(N-1) XOR PLAINTEXT XOR DESIRED_CHARACTER

# Break the input string into blocks
# comment1=cooking
# %20MCs;userdata=
# DUMMY_BLOCK
# ADMIN_BLOCK_HERE
# ;comment2=%20lik
# etc...

# S's to be replaced by semicolons, E to be replaced by equal sign
# A's are to pad
attackString = "A"*16+'SadminEtrueS'+"A"*4

ctCookie = encryptCookieInputCBC(attackString, consistentKey, consistentIV)

# We replace the previous block (DUMMY_BLOCK) with the following:
ctCookie[blockSize*2]= (ctCookie[blockSize*2].ord ^ "S".ord ^ ";".ord).chr
ctCookie[blockSize*2+6]= (ctCookie[blockSize*2+6].ord ^ "E".ord ^ "=".ord).chr
ctCookie[blockSize*2+11]= (ctCookie[blockSize*2+11].ord ^ "S".ord ^ ";".ord).chr

puts validateCookieInputCBC(ctCookie, consistentKey, consistentIV, :debug)