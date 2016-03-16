#!/usr/bin/ruby

# Set 1 - Challenge 7
# Decrypt AES in ECB mode

require './set1Lib.rb'

# Read in and decode from base64
line = File.read('Challenge7TEXT.txt').unpack("m").join

puts decryptAES_ECB(line, "YELLOW SUBMARINE")