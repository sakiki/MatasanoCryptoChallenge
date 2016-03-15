#!/usr/bin/ruby

# Set 1 - Challenge 1
# Convert hex to base 64

def hexToBase64(hexdigest)
	# Pack turns input string into ASCII character based on encoding template
	return [[hexdigest].pack("H*")].pack("m0")
end


# The following prints "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
puts hexToBase64("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d")

# Funny tidbit...the string representation of the hex digest is:
# "I'm killing your brain like a poisonous mushroom"
puts ["49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"].pack("H*")