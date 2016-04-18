#!/usr/bin/ruby

# Set 3 - Challenge 21
# Implement the MT19937 Mersenne Twister PRNG 

require './set3Lib.rb'

raise "Something went wrong" if MT19937.new(0).genRandNum != 2357136044

randoNum = MT19937.new(777)

5.times do 
	p randoNum.genRandNum.to_s(16)
end 