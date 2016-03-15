#!/usr/bin/ruby

# Set 1 - Challenge 3
# Single Character XOR

def decryptSingleByteXOR(hexString, key)
	ret = []
	
	# Scan through each two characters of hex digest and xor with key
	hexString.scan(/../).map {|x| x.hex}.each do |x|
		ret.push((x^key).chr)
	end
	return ret.join
end

def scoreString(countDir)
	# If the character is part of the most common frequency letters increase score
	countDir.each_char.inject(0) do |totalScore, ltr|
		if "etaoin".include?(ltr.downcase)
			totalScore + 1
		else
			# Otherwise do nothing...
			totalScore + 0
		end
	end
end


def scanForSingleByteXOR(hexString)
	likelyKey = 0
	likelyKeyScore = 0

	(0..255).each do |x|
		
		potentialString = decryptSingleByteXOR(hexString,x)
		
		if scoreString(potentialString) > likelyKeyScore
			likelyKeyScore = scoreString(potentialString)
			likelyKey = x
		end

	end

	puts "Likely Key: #{likelyKey}"
	puts decryptSingleByteXOR(hexString,likelyKey)
end

# Outputs: 
# Likely Key: 88
# Cooking MC's like a pound of bacon
scanForSingleByteXOR("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736")