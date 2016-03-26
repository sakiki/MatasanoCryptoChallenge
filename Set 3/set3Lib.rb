#!/usr/bin/ruby

# Set 3 Function Library

# Pull in Set 2 Library

require '../Set 2/set2Lib.rb'

# Challenge 17
def cbcPaddingOracleEncrypt(key)
	
	randomStrArray = []
	
	randomStrArray << "MDAwMDAwTm93IHRoYXQgdGhlIHBhcnR5IGlzIGp1bXBpbmc="
	randomStrArray << "MDAwMDAxV2l0aCB0aGUgYmFzcyBraWNrZWQgaW4gYW5kIHRoZSBWZWdhJ3MgYXJlIHB1bXBpbic="
	randomStrArray << "MDAwMDAyUXVpY2sgdG8gdGhlIHBvaW50LCB0byB0aGUgcG9pbnQsIG5vIGZha2luZw=="
	randomStrArray << "MDAwMDAzQ29va2luZyBNQydzIGxpa2UgYSBwb3VuZCBvZiBiYWNvbg=="
	randomStrArray << "MDAwMDA0QnVybmluZyAnZW0sIGlmIHlvdSBhaW4ndCBxdWljayBhbmQgbmltYmxl"
	randomStrArray << "MDAwMDA1SSBnbyBjcmF6eSB3aGVuIEkgaGVhciBhIGN5bWJhbA=="
	randomStrArray << "MDAwMDA2QW5kIGEgaGlnaCBoYXQgd2l0aCBhIHNvdXBlZCB1cCB0ZW1wbw=="
	randomStrArray << "MDAwMDA3SSdtIG9uIGEgcm9sbCwgaXQncyB0aW1lIHRvIGdvIHNvbG8="
	randomStrArray << "MDAwMDA4b2xsaW4nIGluIG15IGZpdmUgcG9pbnQgb2g="
	randomStrArray << "MDAwMDA5aXRoIG15IHJhZy10b3AgZG93biBzbyBteSBoYWlyIGNhbiBibG93"
	
	
	str = randomStrArray[rand(0..randomStrArray.size-1)].unpack("m").join
	padLength = (str.length.to_f/key.length.to_f).ceil*key.length
	plaintxt = padPKCS7(str,padLength)
	iv = randomAESKey16

	ct = encryptAES_CBC(plaintxt, key, iv)
	
	return [iv, ct]
end

# Simply validates CBC encryption padding
def cbcPaddingOracleDecrypt(ct, key, iv)
	paddedStr = decryptAES_CBC(ct, key, iv)		

	blocksize = key.length
	paddingCount = paddedStr[-1].ord	
	return false if paddingCount > 16
	paddingNums = paddedStr[-paddingCount..paddedStr.length]
	nonPaddedString = paddedStr[0..(((paddedStr.length-paddingCount))-1)]
	nonPaddedString = "" if paddingCount == blocksize
	return false if (paddingNums.length + nonPaddedString.length) % blocksize != 0
	return false if paddingNums.bytes.to_a.uniq.size != 1
	
	return true
end

# Here is the logic:

# It is easiest to think of this two blocks at a time.

# The first block is getting XOR'd with the decrypted intermediate 
# state of the second one.  The key to this attack is that we know the plain text
# and can modify the first block to find the intermediate states.

# Recall:
# INTERMEDIATE_STATE = PLAINTEXT XOR CIPHERTEXT(N-1)

# and therefore

# PLAINTEXT = CIPHERTEXT(N-1) XOR INTERMEDIATE_STATE

# We must first find the intermediate state of the last byte of plaintext.  Since we know 
# that valid padding only occurs when the last byte is \x01, we cycle through ATTACK_STR(N-1)[15]
# values until we validate the padding.  ATTACK_STR is 16 bytes in length and the other values 
# can be random.  Therefore we have the last byte of the intermediate state:

# INTERMEDIATE_STATE[15] = 01 XOR ATTACK_STR(N-1)[15]

# This INTERMEDIATE_STATE[15] byte can be XOR'd with the CIPHERTEXT(N-1)[15] byte to find the real 
# value of CIPHERTEXT(N)[15]!

# For the next byte we must realize that the plain text for the last two bytes of the PLAINTEXT
# will be \x02.  We know the intermediate state for the last byte but not the second-to-last byte.
# To find it, we construct an "attack block" with 14 random values (1 less than last time), our 
# unknown value and the previous INTERMEDIATE_STATE byte XOR'd with 02.

# When we validate we know that:

# INTERMEDIATE_STATE[14] = 02 XOR ATTACK_STR(N-1)[14]

# We can then take INTERMEDIATE_STATE[14] and XOR it with CIPHERTEXT(N-1)[14] to find the real value 
# of CIPHERTEXT(N)[14]!

# Continue until you are done with the block

def cbcPaddingOracleBlockAttack(cbcBlockOne, cbcBlockTwo, key, debug=nil)
	printf("Debug Cheat Part A: %s\n", decryptAES_CBC(cbcBlockTwo, key, cbcBlockOne)) if debug == :debug
	blocksize = key.length 
	

	message = ""
	intermediateArray = Array.new blocksize
	
	(1..16).each do |i|
		
		attackBlock = ""
		(blocksize-i).times {attackBlock.concat(rand(0..255).chr)}
		
		(0..255).each do |n|
			if i == 1
				# There is no intermediate stage developed yet
				currentAttackBlock=  attackBlock + n.chr + cbcBlockTwo
			else
				currentAttackBlock=  attackBlock + n.chr				
				currentAttackBlock += intermediateArray[(blocksize-(i-1))..(blocksize-1)].map{|x| (x.ord ^ i.ord).chr }.join
				currentAttackBlock += cbcBlockTwo	
			end
			
			raise "Invalid Length" if currentAttackBlock.length != 32
			# You can think of the first block acting as an IV since we only deal with two blocks at a time
			if cbcPaddingOracleDecrypt(currentAttackBlock, key, cbcBlockOne)
			
				intermediateArray[blocksize-i] = n.ord^i.ord
				
				message += (n.ord^i.ord ^ cbcBlockOne[blocksize-i].ord).chr	
				
			end
		end
	
	end
	printf("Debug Cheat Part B: %s\n", message.chars.reverse.join) if debug == :debug
	return message.chars.reverse.join

	
end

def cbcPaddingOracleAttack(iv, ciphertxt, key, debug=nil)
	combinedCipherStr = [iv,ciphertxt].join
	message = []
	breakIntoBlocks(combinedCipherStr, key.length, 2) do |blockOne, blockTwo|
		message << cbcPaddingOracleBlockAttack(blockOne, blockTwo, key, debug)
	end
	return message.join
end

# Challenge 18