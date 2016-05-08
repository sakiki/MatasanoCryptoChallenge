#!/usr/bin/ruby

# Set 4 - Challenge 27
# Recover the key from CBC with IV=key 

require './set4Lib.rb'

# Logic
# Assuming I_n is the nth intermediate state (the state after the AES block function)
# Making the message from C_1, C_2, C_3 to C_1, 0, C_1 
# P_1 = I_1 ^ key 
# P_2 = I_2 ^ C_1 
# P_3 = I_3 ^ 0 
# P_1 ^ P_3 = KEY since I_1 = I_3 

inputStr = "A"*16+"B"*16+"C"*16 
key = randomAESKey16
iv = key 

ct = encryptAES_CBC(inputStr, key, iv)
c1 = ct[0..15]

modifiedCiphertext = c1 + "\0"*16 + c1 

# We do this because the padding is all messed up in modifiedCiphertext
blockSize = 16 
pArray = Array.new 
ciphertext = iv+modifiedCiphertext

breakIntoBlocks(ciphertext, blockSize, 2) do |blockOne, blockTwo|
	plainBlock = decryptAES_ECB(blockTwo, key)
	xorBlock = blockXOR(plainBlock, blockOne)
	pArray << xorBlock
end 

recoveredKey = blockXOR(pArray[0], pArray[2])
raise "WRONG" if key != recoveredKey
puts recoveredKey