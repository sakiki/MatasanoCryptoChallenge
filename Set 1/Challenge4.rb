#!/usr/bin/ruby

# Set 1 - Challenge 4
# Detect single-character XOR

require './set1Lib.rb'

likelyCypherTxt = ""
likelyKeyScore = 0
likelyKey = 0

File.open("Challenge4TEXT.txt").each do |line|
	potentialKey = scanForSingleByteXORKey(line)
	potentialString = decryptSingleByteXOR(line, potentialKey)
	
	if scoreString(potentialString) > likelyKeyScore
		likelyKeyScore = scoreString(potentialString)
		likelyCypherTxt = line 
		likelyKey = potentialKey
	end
end

# Outputs:
# 7b5a4215415d544115415d5015455447414c155c46155f4058455c5b523f
# Now that the party is jumping
puts likelyCypherTxt
puts decryptSingleByteXOR(likelyCypherTxt, likelyKey)