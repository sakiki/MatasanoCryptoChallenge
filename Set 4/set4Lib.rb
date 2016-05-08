#!/usr/bin/ruby

# Set 4 Function Library

# Pull in Set 3 Library

require '../Set 3/set3Lib.rb'

# Challenge 25
# Offset starts at zero 
def editCTRCipherText(ciphertxt, nonce,key,offset,newtext)
	raise "Can not replace new text due to length" if offset+newtext.length > ciphertxt.length 
	pt = aesCTROperation(ciphertxt, nonce, key)
	pt[offset..offset+newtext.length-1] = newtext 
	return aesCTROperation(pt, nonce, key)
end 

# Challenge 26 
def encryptCookieInputCTR(inputStr, nonce, key)
	inputStr.gsub!(/[;=]/,'')
	inputStr = "comment1=cooking%20MCs;userdata=" + inputStr + ";comment2=%20like%20a%20pound%20of%20bacon"
	ct = aesCTROperation(inputStr, nonce, key)
	return ct 
end 

def validateCookieInputCTR(ciphertxt, nonce, key, debug=nil)
	pt = aesCTROperation(ciphertxt, nonce, key)
	tempDict = kvParse(pt, ';')
	puts pt if debug == :debug 
	return tempDict['admin'] == "true" ? true:false 
end 

# Challenge 28 
# Using FIPS 180-2 as a reference...
class SHA1 
	
	def self.f(x,y,z,t)
		if (0..19).include? t 
			return (x & y) ^ (~x & z)
		elsif (20..39).include? t 
			return (x^y^z)
		elsif (40..59).include? t
			return (x&y) ^ (x&z) ^ (y&z)
		elsif (60..79).include? t
			return (x^y^z)
		end
	end 
	
	def self.k(t)
		if (0..19).include? t 
			return 0x5a827999
		elsif (20..39).include? t 
			return 0x6ed9eba1
		elsif (40..59).include? t
			return 0x8f1bbcdc
		elsif (60..79).include? t
			return 0xca62c1d6
		end
	end 	
	
	def self.ROTL(intToRotate, bits)
		return ((intToRotate << bits) | (intToRotate >> (32-bits))) & 0xFFFFFFFF
	end 
	
	def self.hexDigest(input)
		# I don't want UTF-16 ruby...
		input = input.force_encoding("ASCII-8BIT")
		originalLength = input.length 
		# We want a one followed by 7 zeroes in binary aka 0x80
		input << 0x80 
		# 5.1.1 of FIPS 180-2 states it should be input.length % 512 != 448 but 
		# .. a hex value here is 8 bits.  So we divide by 8 to get the right length. 
		input << 0 while input.length % (512/8) != (448/8)
		
		# We need to add the length as a 64-bit big-endian number 
		# Each character is 8 bits long so multiply by 8 
		# Add the extra 4 zeroes (32 bits) because pack('N*') is big endian 32-bit formatting 
		input += ("\x0"*4+ [originalLength*8].pack('N*'))
	
		h0 = 0x67452301
		h1 = 0xefcdab89
		h2 = 0x98badcfe 
		h3 = 0x10325476
		h4 = 0xc3d2e1f0

		# Break into 512 bit chunks (note 8 bits per character)
		input.unpack("C*").each_slice(64) do |chunk|
			w = Array.new

			# Take the 16 32-bit words (512 bits) and put them into the message schedule 
			chunk.each_slice(4) do |a,b,c,d|

				# Concat the bit versions of these 4 values together as a 32-bit word 
				w << (((a << 8 | b) << 8 | c ) << 8 | d )
			end 
			
			(16..79).each do |t|
				w << ROTL((w[t-3]^w[t-8]^w[t-14]^w[t-16]),1)
			end 

			a = h0 
			b = h1 
			c = h2 
			d = h3 
			e = h4 
			
			(0..79).each do |t| 
				tvar = (ROTL(a,5) + f(b,c,d,t) + e + k(t)+w[t]) & 0xFFFFFFFF
				e = d 
				d = c 
				c = ROTL(b,30)
				b = a 
				a = tvar 

			end 
			
			h0 = h0 + a & 0xFFFFFFFF
			h1 = h1 + b & 0xFFFFFFFF
			h2 = h2 + c & 0xFFFFFFFF
			h3 = h3 + d & 0xFFFFFFFF
			h4 = h4 + e & 0xFFFFFFFF
			
		end 
		
		return [h0,h1,h2,h3,h4].map{ |i| i.to_s(16) }.join 
	end 
	
end 

def sha1KeyedMAC(inputstr)
	theSuperSecretKey = "Password1234"
	return SHA1.hexDigest(theSuperSecretKey + inputstr)
end 