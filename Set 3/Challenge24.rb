#!/usr/bin/ruby

# Set 3 - Challenge 24
# Create the MT19937 stream cipher and break it

require './set3Lib.rb'

seed = rand(0..0xFFFF)
printf("Cheat: %d\n", seed)
knownPlaintxt = "A"*14

ciphertxt = prngCTROperation("S"*rand(0..10) + knownPlaintxt, seed)

(0..0xFFFF).each do |i|
	result = prngCTROperation(ciphertxt, i )
	if result.include? knownPlaintxt
		printf("Current iter: %d\n", i)
		break 
	end 
end 

puts '-'*10 

# Part 2 
initialTimeSeed = Time.new.strftime("%s").to_i
passwordToken = makeKeyStream(32, initialTimeSeed)

printf("Time Cheat: %d\n", initialTimeSeed)

sleep(rand(0..10))

currentTime = Time.new
(0..5000).each do |i|
	backInTime = currentTime - i 
	testToken = makeKeyStream(32, backInTime.strftime("%s").to_i)
	
	if testToken == passwordToken
		puts "We got it."
		printf("%d Seconds ago\n", i)
		puts backInTime.strftime("%s").to_i 
		break 
	end 
end 