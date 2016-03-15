#!/usr/bin/ruby

# Set 1 - Challenge 2
# Fixed XOR

def fixedXOR(hexString1, hexString2)
	return (hexString1.hex ^ hexString2.hex).to_s(16)
end


# Outputs "746865206b696420646f6e277420706c6179"
puts fixedXOR("1c0111001f010100061a024b53535009181c", "686974207468652062756c6c277320657965")