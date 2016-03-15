#!/usr/bin/ruby

# Set 1 - Challenge 5
# Repeating key XOR


def repeatingXOR(plaintxt, key)

# Find key multiply number

	keyMult = (plaintxt.length.to_f/key.length.to_f).ceil
	
	key = key*keyMult
	key = key[0..plaintxt.length-1]

	plaintxt = plaintxt.bytes
	key = key.bytes
	
	return plaintxt.zip(key).map {|a,b| sprintf("%02x", (a^b))}.join
end

# Outputs
# "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
puts [repeatingXOR("Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal","ICE")]
