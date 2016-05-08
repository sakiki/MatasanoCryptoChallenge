#!/usr/bin/ruby

# Set 4 - Challenge 25
# Break "random access read/write" AES CTR

require './set4Lib.rb'

consistentKey = randomAESKey16
nonce = randomAESKey16[0..7]

lines = File.open('CHALLENGE25TXT.txt').readlines.map(&:strip).join
ct = aesCTROperation(lines,nonce,consistentKey)


ct = editCTRCipherText(ct, nonce, consistentKey, 0, ct)
raise "We broke the universe" if ct != lines 
p ct 