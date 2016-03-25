#!/usr/bin/ruby

# Set 2 - Challenge 11
# ECB/CBC Detection Oracle

require './set2Lib.rb'

blockSize = 16

# A little stress testing...
(0..5).each do 
	pt = "b"*(blockSize*4)
	ct = encryptionOracle(pt, :debug)
	printf("Detection Function says: ")
	puts detectCipher(ct, blockSize)
	puts "-"*10
end