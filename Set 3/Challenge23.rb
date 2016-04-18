#!/usr/bin/ruby

# Set 3 - Challenge 23
# Clone an MT19937 PRNG from its output

require './set3Lib.rb'

theRealOne = MT19937.new(777)
theCloneOne = MT19937CLONE.new(192)

clonedState = Array.new 
(0..623).each do |i|
	clonedState.push untemper(theRealOne.genRandNum)
end 
	
theCloneOne.setState(clonedState)

10.times {
	x = theRealOne.genRandNum
	y = theCloneOne.genRandNum
	
	raise "WRONG" if x != y
	
	printf("%d: %d\n", x, y)
}
	