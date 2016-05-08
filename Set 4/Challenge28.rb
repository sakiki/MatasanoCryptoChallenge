#!/usr/bin/ruby

# Set 4 - Challenge 28
# Implement SHA-1 in Ruby 

require './set4Lib.rb'

raise "What? Probably an encoding error..." if SHA1.hexDigest("abc") != "a9993e364706816aba3e25717850c26c9cd0d89d"

puts sha1KeyedMAC("asdf")