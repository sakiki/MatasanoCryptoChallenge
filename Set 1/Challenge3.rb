#!/usr/bin/ruby

# Set 1 - Challenge 3
# Single Character XOR

require './set1Lib.rb'


# Outputs:
# 88
# Cooking MC's like a pound of bacon
key = scanForSingleByteXORKey("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736")
puts key
puts decryptSingleByteXOR("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736", key)