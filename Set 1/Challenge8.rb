#!/usr/bin/ruby

# Set 1 - Challenge 8
# Detect AES in ECB mode

require './set1Lib.rb'

# Read in hex digests
lines = File.open('Challenge8TEXT.txt').readlines.map(&:strip).join

blockArray = Array(breakIntoBlocks(lines,32, 1) {|blockOne| blockOne})
blockArray.uniq.map { |x| [blockArray.count(x), x] }.select{ |y, _| y > 1 }.map{|x,y| puts "#{y}: #{x}"}