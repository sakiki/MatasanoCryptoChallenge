#!/usr/bin/ruby

# Set 2 - Challenge 15
# PKCS#7 padding Validation

require './set2Lib.rb'

sampleString = padPKCS7("ICE ICE BABY", 16)

puts unpadPKCS7(sampleString, 16)
