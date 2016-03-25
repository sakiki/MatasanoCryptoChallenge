#!/usr/bin/ruby

# Set 1 Function Library

require 'openssl'

# Challenge 1
def hexToBase64(hexDigest)
	return [[hexDigest].pack("H*")].pack("m0")
end

# Challenge 2
def fixedXOR(hexDigest1, hexDigest2)
	return (hexDigest1.hex ^ hexDigest2.hex).to_s(16)
end

# Challenge 3 and 4
def decryptSingleByteXOR(hexDigest, key)
	ret =[]
	# Scan through each two characters of hex digest and xor with key
	hexDigest.scan(/../).map{|x| x.hex}.each do |x|
		ret.push((x^key).chr)
	end
	return ret.join
end

def scoreString(countDir)
	# If the character is part of the most common frequency letters increase score 
	countDir.each_char.inject(0) do |totalScore, ltr|
		if "ETAOIN SHRDLU".include?(ltr.upcase)
			totalScore + 1
		else
			# Otherwise do nothing...
			totalScore + 0
		end 
	end 
end 

def scanForSingleByteXORKey(hexDigest)
	likelyKey = 0
	likelyKeyScore = 0
	
	(0..255).each do |x|
		potentialString = decryptSingleByteXOR(hexDigest, x)
		
		if scoreString(potentialString) > likelyKeyScore
			likelyKeyScore = scoreString(potentialString)
			likelyKey = x
		end
	
	end
	
	return likelyKey
end

# Challenge 5
def repeatingXOREncrypt(plaintxt, key)
	# Find key multiply number
	keyMult = (plaintxt.length.to_f/key.length.to_f).ceil
	key = (key*keyMult)[0..plaintxt.length-1]
	
	# Use sprintf because sometimes leading zeroes are left out
	return plaintxt.bytes.zip(key.bytes).map {|a,b| sprintf("%02x", (a^b))}.join

end

# Challenge 6
def hammingDist(str1, str2)
	return unless str1.length == str2.length
	str1 = str1.unpack("B*").join
	str2 = str2.unpack("B*").join 
	
	return str1.bytes.zip(str2.bytes).count {|s1,s2| s1 != s2}
end

def breakIntoBlocks(line, blockSize, oneOrTwo)
	# Holds the results of yielding
	blockFunctionArray = []
	
	# General (Sliding Block) Method
	numberOfBlocks = line.length/blockSize
	
	# Subtract two because we jump two at a time
	(0..numberOfBlocks-oneOrTwo).each do |blockNum|
	
		# This method slides the boundary of the sub-block 
		# .. based on block sizes
		subBlock = line[blockNum*blockSize..line.length]
		
		# Take a two block cut of the sub-block
		blockOne = subBlock[0..blockSize-1]
		
		if oneOrTwo == 2
			blockTwo = subBlock[blockSize..(2*blockSize)-1]
		
			# Yield to outside function
			blockFunctionArray << yield(blockOne, blockTwo)	
		else 
			blockFunctionArray << yield(blockOne)	
		end
	end
	
	return blockFunctionArray
	
end

def scanForMultiByteXORKeySize(ciphertxt)
	# Stupid large value
	lowestDist = 5000000
	likelyKeySize = 0
	
	(2..40).each do |keysize|
		normDistance = 0
		hamming = Array.new 
		hamming = breakIntoBlocks(ciphertxt, keysize, 2) do |blockOne, blockTwo|
		
			#Compute hamming distance
			hDist = hammingDist(blockOne, blockTwo)
			
			# Load normalized hamming distance
			hDist/keysize
		end
		
		# Average all hamming distances into one value
		normDistance = hamming.inject(0.0){|total,ind| total += ind}/hamming.size
		
		if normDistance < lowestDist
			lowestDist = normDistance
			likelyKeySize=keysize
		end
	
	end
	
	return likelyKeySize

end

def findTransposedBlocks(ciphertxt, keysize)
	transposedHash = {}
	blockArray = Array.new
	# Ignore second argument in Proc
	blockArray = breakIntoBlocks(ciphertxt, keysize, 1) do |blockOne|
		blockOne
	end
	
	blockArray.each do |block|
		index = 0 
		block.chars.each do |ltr|
			transposedHash[index] = Array.new if transposedHash[index].nil?
			transposedHash[index] << ltr
			index += 1
		end
	end
	
	return transposedHash
end

def scanForMultiByteXORKey(transposedBlockHash)
	keyArr = Array.new
	
	transposedBlockHash.keys.each do |key|
		transposedBlock = transposedBlockHash[key].join
		keyArr << scanForSingleByteXORKey(transposedBlock.unpack("H*").join)			  
	end
	
	actualKey = keyArr.map(&:chr).join
	return actualKey
end

# Challenge 7
def decryptAES_ECB(ciphertxt, key)
	
	cipher = OpenSSL::Cipher.new 'AES-128-ECB'
	cipher.decrypt
	cipher.key = key 
	# Need padding = 0 for CBC Implementation
	cipher.padding = 0
	plaintxt = cipher.update(ciphertxt) + cipher.final
	return plaintxt 
end

def encryptAES_ECB(plaintxt, key)
	
	cipher = OpenSSL::Cipher.new 'AES-128-ECB'
	cipher.encrypt
	cipher.key = key 
	# Need padding = 0 for CBC Implementation
	cipher.padding = 0
	ciphertxt = cipher.update(plaintxt) + cipher.final
	return ciphertxt

end















