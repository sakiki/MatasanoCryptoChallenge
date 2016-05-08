#!/usr/bin/ruby

# Set 4 - Challenge 26
# CTR bitflipping

require './set4Lib.rb'

consistentKey = randomAESKey16
nonce = randomAESKey16[0..7]

blockSize = 16

# S's to be replaced by semicolons, E to be replaced by equal sign
# A's are to pad 
attackString = 'SadminEtrueS' + "A"*4


ctCookie = encryptCookieInputCTR(attackString,nonce,consistentKey)

ctCookie[blockSize*2]= (ctCookie[blockSize*2].ord ^ "S".ord ^ ";".ord).chr
ctCookie[blockSize*2+6]= (ctCookie[blockSize*2+6].ord ^ "E".ord ^ "=".ord).chr
ctCookie[blockSize*2+11]= (ctCookie[blockSize*2+11].ord ^ "S".ord ^ ";".ord).chr

puts validateCookieInputCTR(ctCookie, nonce, consistentKey, :debug)