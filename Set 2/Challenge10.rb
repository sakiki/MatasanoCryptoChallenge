#!/usr/bin/ruby

# Set 2 - Challenge 10
# Implement CBC Mode

require './set2Lib.rb'

# 16 byte block size for 128 bit key
blockSize = 16

# Convert to hexadecimal encoding i.e. "\x00\x00"
iv=("0"*blockSize).chars.map{|x| x.to_i.chr}.join
key = "YELLOW SUBMARINE"

ciphertxt = File.read('Challenge10TEXT.txt').unpack('m').join
pt = decryptAES_CBC(ciphertxt, key, iv)

puts pt