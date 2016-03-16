#!/usr/bin/ruby

# Set 1 - Challenge 6
# Break Repeating key XOR

require './set1Lib.rb'

raise "Wrong hamming distance" unless hammingDist("this is a test", "wokka wokka!!!")==37

# Read in and decode from base64
line = File.read('Challenge6TEXT.txt').unpack("m").join

potentialKeySize = scanForMultiByteXORKeySize(line)
transposedHash = findTransposedBlocks(line, potentialKeySize)
actualKey = scanForMultiByteXORKey(transposedHash)

# Key is: Terminator X: Bring the noise
puts actualKey
puts [repeatingXOREncrypt(line,actualKey)].pack("H*")