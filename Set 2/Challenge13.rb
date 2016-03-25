#!/usr/bin/ruby

# Set 2 - Challenge 13
# ECB Cut and Paste

require './set2Lib.rb'

consistentKey = randomAESKey16

blockSize = consistentKey.length
blockSizeHex = blockSize*2

# Fill the remaining 10 bytes in the block starting with email=...
# so that we have a block with only "admin" in it.
attackString = "A"*10 + "admin"+"\0"*11
attackBlock = profileOracle(attackString, consistentKey)
# The block with admin in it is the second block
attackBlock = attackBlock[blockSizeHex..blockSizeHex*2-1]

profile = "a@a.com"
decryptedProfile = ""
loop do 
	targetBlock = profileOracle(profile, consistentKey)
	# Remove the last block which ideally contains the user part of the string
	targetBlock = targetBlock[0..targetBlock.length-(blockSizeHex)-1]
	decryptedProfile = profileDecrypt(targetBlock+attackBlock, consistentKey)
	puts decryptedProfile
	
	break if decryptedProfile.match("role=admin")
	profile = "a" + profile
end

puts '-'*10
puts decryptedProfile