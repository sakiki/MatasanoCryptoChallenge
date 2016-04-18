#!/usr/bin/ruby

# Set 3 - Challenge 22
# Crack an MT19937 seed 

require './set3Lib.rb'

initialWait = rand(40..1000)
postWait = rand(40..1000)

puts "Sleeping #{initialWait} seconds..."
sleep(initialWait)

currentTime = Time.new
seed = currentTime.strftime("%s").to_i
puts "Seed is: #{seed}"

randoNum = MT19937.new(seed).genRandNum 

puts "Sleeping #{postWait} seconds..."
sleep(postWait)

# How far back do you want to time travel (in seconds)?
bruteForceTimeTravelConstant = 1000

(0..bruteForceTimeTravelConstant).each do |i|
	currentTime = Time.new 
	puts "Time traveling #{i} seconds ago"
	pastTimeSeed = (currentTime - i).strftime("%s").to_i 
	if MT19937.new(pastTimeSeed).genRandNum == randoNum
		puts "Cracked with seed of #{pastTimeSeed}"
		break 
	end 

end 