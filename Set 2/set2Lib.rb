#!/usr/bin/ruby

# Set 2 Function Library

# Pull in Set 1 Library

require '../Set 1/set1Lib.rb'

# Challenge 9
def padPKCS7(str,padLength)
	raise "Invalid padding arguments" if (str.length > padLength)
	remainingLength = padLength-str.length
	remainingLength = 16 if remainingLength == 0
	finalStr = str
	remainingLength.times{finalStr.concat(remainingLength.chr)}
	return finalStr
end

# Challenge 10
def blockXOR(rawStr1, rawStr2)
	return rawStr1.bytes.zip(rawStr2.bytes).map{|x,y| (x^y).chr}.join
end

def decryptAES_CBC(ciphertxtraw, key,iv)
	# 16 byte block size for 128 bit key
	blockSize = 16
	pArray = Array.new
	ciphertxt = iv+ciphertxtraw
	
	
	breakIntoBlocks(ciphertxt, blockSize, 2) do |blockOne, blockTwo|
		plainBlock = decryptAES_ECB(blockTwo, key)
		xorBlock = blockXOR(plainBlock, blockOne)
		pArray << xorBlock
	end
	
	return unpadPKCS7(pArray.join, blockSize)
end

def encryptAES_CBC(plaintxtraw, key, iv)
	# 16 byte block size for 128 bit key
	blockSize = 16
	cArray = [iv]
	
	padLength = (plaintxtraw.length.to_f/key.length.to_f).ceil*key.length
	plaintxtraw = padPKCS7(plaintxtraw,padLength)
	
	breakIntoBlocks(plaintxtraw, blockSize, 1) do |blockOne|
		xorBlock = blockXOR(blockOne, cArray[-1])
		cipherBlock = encryptAES_ECB(xorBlock,key)
		cArray << cipherBlock
	end
	
	# Strip iv
	cArray = cArray[1..cArray.size]
	
	return cArray.join
end

# Challenge 11
def randomAESKey16
	finalStr = ""
	16.times {finalStr.concat(rand(0..255).chr)}
	return finalStr
end
	
def encryptionOracle(str, debug=nil)
	plaintxt = ('b'*rand(5..10))+str+('a'*rand(5..10))
	key = randomAESKey16
	blockSize = key.length
	
	if rand(0..1) == 1
	
		# CBC Mode
		
		# Convert to hexadecimal encoding i.e. "\x00\x00"
		iv = ""
		blockSize.times{iv.concat(rand(0..15).chr)}
		puts "Encryption Oracle Cheat: CBC" if debug == :debug
		return encryptAES_CBC(plaintxt, key, iv)
	else
	
		# ECB Mode
		puts "Encryption Oracle Cheat: ECB" if debug == :debug
		cipher = OpenSSL::Cipher.new 'AES-128-ECB'
		cipher.encrypt
		cipher.key = key 
		ciphertxt = cipher.update(plaintxt) + cipher.final
		return ciphertxt
	end
end

def detectCipher(ciphertxtRaw, blockSize)
	ciphertxtdigest = ciphertxtRaw.unpack("H*").join
	
	# Multiply by 2 because we convert from raw to hex (2 characters per byte)
	blockArray = Array(breakIntoBlocks(ciphertxtdigest, 2*blockSize, 1){|blockOne| blockOne})
	# Remember: ECB is consistent, find the hash with duplicate blocks
	if (blockArray.uniq.map { |x| [blockArray.count(x), x] }.select{ |y, _| y > 1 }.count >= 1)
		return 'ECB'
	else
		return 'CBC'
	end
end

# Challenge 12

def consistentEncryptionOracle(str, key)
	padLength = (str.length.to_f/key.length.to_f).ceil*key.length
	plaintxt = padPKCS7(str,padLength)
	
	# ECB Mode
	cipher = OpenSSL::Cipher.new 'AES-128-ECB'
	cipher.encrypt
	cipher.key = key 
	# We do not need padding on this one because
	# .. we do it ourselves 
	cipher.padding = 0
	ciphertxt = cipher.update(plaintxt) + cipher.final
	return ciphertxt
end

def discoverBlockSize(unknownStr, key)
	originalLength = consistentEncryptionOracle(unknownStr, key).length
	
	(1..255).to_a.each do |n|
		pt = "A"*n
		pt = unknownStr + pt
		ct = consistentEncryptionOracle(pt, key)
		
		# When the length changes we know that we have reached a new block,
		# .. because PKCS #7 padding adds BLOCKSIZE # of values in a new block
		if ct.length > originalLength
			return ct.length - originalLength
		end
	
	end
end

def attackECBBlock(ecbBlock, consistentKey)
	i = 1
	blockMessage = []
	blockSize = ecbBlock.length
	ecbBlock.chars.each do |y|
		shortInputBlock = "A"*(blockSize-i)
		ctShort = consistentEncryptionOracle(shortInputBlock+ecbBlock,consistentKey)
		ctShort = ctShort[0..blockSize-1]
		
		shortInputBlock = "A"*(blockSize-i)+blockMessage.join
		
		(0..255).each do |x|
			ctAttack = consistentEncryptionOracle(shortInputBlock+x.chr+ecbBlock, consistentKey)
			ctAttack = ctAttack[0..blockSize-1]
			
			if ctShort == ctAttack
				blockMessage << x.chr
			end
		end
		i += 1
	end
	return blockMessage
end

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

def attackECBCipher(ecbString, consistentKey)
	overallMessage = []
	blockSize = consistentKey.length
	breakIntoBlocks(ecbString, blockSize, 1) do |blockOne|
		overallMessage << attackECBBlock(blockOne, consistentKey)
	end
	return overallMessage.join
end

# Challenge 13
def kvParse(kvString, splitOn='&')
	tempDict = {}
	kvString.split(splitOn).map do |kv|
		tempDict[kv.split('=')[0]]=kv.split('=')[1]
	end
	return tempDict
end

def profileFor(emailStr)
	tempDict = {}
	emailStr.gsub!(/[&=]/, '')
	tempDict["email"] = emailStr
	tempDict["uid"] = 10
	tempDict["role"] = "user"
	
	return tempDict.map{|k,v| [k,v].join("=")}.join("&")
end

def profileEncrypt(profileStr, key)
	padLength = (profileStr.length.to_f/key.length.to_f).ceil*key.length
	plaintxt = padPKCS7(profileStr, padLength)
	# ECB Mode
	cipher = OpenSSL::Cipher.new 'AES-128-ECB'
	cipher.encrypt
	cipher.key = key 
	# We do not need padding on this one because
	# .. we do it ourselves 
	cipher.padding = 0
	ciphertxt = cipher.update(plaintxt) + cipher.final
	return ciphertxt.unpack("H*").join
end

def profileDecrypt(profileStr, key)
	return decryptAES_ECB([profileStr].pack("H*"), key)
end

def profileOracle(emailStr, key)
	return profileEncrypt(profileFor(emailStr), key)
end

# Challenge 14
def randomPrepend
	finalStr = ""
	rand(1..16).times { finalStr.concat(rand(0..255).chr)}
	return finalStr
end

# In the prepend version, the encryption oracle always prepends the 
# .. string before sending it to the oracle
def attackECBBlockPrepend(ecbBlock, consistentKey, prepend, randomPrependStr)
	i = 1 
	blockMessage = []
	blockSize = ecbBlock.length 
	
	# We need to adjust the block index depending how long this is
	blockMultiplier = (randomPrependStr + prepend + "A"*(blockSize-1)).length/blockSize
	ecbBlock.chars.each do |y|
		shortInputBlock = "A"*(blockSize-i)
		ctShort = consistentEncryptionOracle(randomPrependStr + prepend +shortInputBlock+ecbBlock, consistentKey)
		ctShort = ctShort[blockSize*blockMultiplier..(blockSize*(blockMultiplier+1))-1]
		shortInputBlock = "A"*(blockSize-i) + blockMessage.join 
		
		(0..255).each do |x| 
			ctAttack = consistentEncryptionOracle(randomPrependStr + prepend +shortInputBlock+x.chr+ecbBlock, consistentKey)
			ctAttack = ctAttack[blockSize*blockMultiplier..(blockSize*(blockMultiplier+1))-1]

			if ctShort == ctAttack
				blockMessage << x.chr 
			end 
		end 
		
		i += 1 
	end 
	return blockMessage
end 


def attackECBCipherPrepend(ecbString, consistentKey, prepend, randomPrependStr)
	overallMessage = []
	blockSize = consistentKey.length
	breakIntoBlocks(ecbString, blockSize, 1) do |blockOne|
		overallMessage << attackECBBlockPrepend(blockOne, consistentKey, prepend, randomPrependStr)
	end
	return overallMessage.join
end

# Challenge 15
def unpadPKCS7(paddedStr, blocksize)
	paddingCount = paddedStr[-1].ord
	raise "Padding Count Error" if paddingCount > 16
	paddingNums = paddedStr[-paddingCount..paddedStr.length]
	nonPaddedString = paddedStr[0..(((paddedStr.length-paddingCount))-1)]
	# If paddedStr is all \x16 for an empty string then we have to accommodate:
	nonPaddedString = "" if paddingCount == blocksize
	raise "Padding Length Error" if (paddingNums.length + nonPaddedString.length) % blocksize != 0
	raise "Padding not the same Error" if paddingNums.bytes.to_a.uniq.size != 1
	return nonPaddedString
end

# Challenge 16
# This looks like cookie data so that's what I'm going to name it
def encryptCookieInputCBC(inputStr, key, iv)
	inputStr.gsub!(/[;=]/,'')
	inputStr = "comment1=cooking%20MCs;userdata=" + inputStr + ";comment2=%20like%20a%20pound%20of%20bacon"
	ct = encryptAES_CBC(inputStr, key, iv)
	return ct
end

def validateCookieInputCBC(ciphertxt, key, iv, debug=nil)
	pt = decryptAES_CBC(ciphertxt, key, iv)
	tempDict = kvParse(pt, ';')
	puts pt if debug == :debug
	return tempDict['admin'] == "true" ? true: false
end







