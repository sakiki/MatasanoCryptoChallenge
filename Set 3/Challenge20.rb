#!/usr/bin/ruby

# Set 3 - Challenge 20
# Break fixed-nonce CTR mode statistically

require './set3Lib.rb'

lines = File.open('CHALLENGE20TEXT.txt').readlines.map(&:strip).map{|x| x.unpack("m").join}

consistentKey = randomAESKey16

nonce = "\0"*8
ctArr = Array.new 

ctArr = lines.map do |x|
	aesCTROperation(x,nonce, consistentKey)
end 

# Find the string with the smallest length 
minimumLength = ctArr.min {|a,b| a.length <=> b.length}.length 

# Truncate all lines in array to shortest and concatenate all of them together 
ct = ctArr.map{|x| x[0..minimumLength-1]}.join 

transposedHash = findTransposedBlocks(ct, minimumLength)
actualKey = scanForMultiByteXORKey(transposedHash)

keyMult = (ct.length.to_f/actualKey.length.to_f).ceil
key = (actualKey*keyMult)[0..ct.length-1]

puts ct.chars.zip(key.chars).map {|a,b| (a.ord^b.ord).chr}.join