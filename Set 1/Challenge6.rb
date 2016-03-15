#!/usr/bin/ruby

# Set 1 - Challenge 5
# Break Repeating key XOR

def hammingDist(str1,str2)
	return unless str1.length == str2.length
	str1 = str1.unpack("B*").join
	str2 = str2.unpack("B*").join
	return str1.bytes.zip(str2.bytes).count {|s1,s2| s1 != s2}
end

raise "Wrong hamming Distance" unless hammingDist("this is a test", "wokka wokka!!!")==37

keysizeDir = {}

(2..41).each do |keysize|

	line = "HUIfTQsPAh9PE048GmllH0kcDk4TAQsHThsBFkU2AB4BSWQgVB0dQzNTTmVS"
	
	line = line.unpack("m").join
	
	firstHalf = line[0..keysize-1]
	secondHalf = line[keysize..2*keysize-1]
	
	normDistance = hammingDist(firstHalf,secondHalf).to_f/keysize.to_f

	
	keysizeDir[keysize]=normDistance	

end


keysizeDir.values.sort.each do |x|
puts x
	
end

