#!/usr/bin/ruby

# Set 1 - Challenge 4
# Detect single-character XOR


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

	return decryptSingleByteXOR(hexString,likelyKey)
end

likelyCypherTxt = ""
likelyKeyScore = 0

File.open('Challenge4TEXT.txt').each do |line|
	potentialString = scanForSingleByteXOR(line)
	if scoreString(potentialString) > likelyKeyScore
			likelyKeyScore = scoreString(potentialString)
			likelyCypherTxt = line
	end


end

# Outputs
# 7b5a4215415d544115415d5015455447414c155c46155f4058455c5b523f
# Now that the party is jumping
puts likelyCypherTxt
puts scanForSingleByteXOR(likelyCypherTxt)



