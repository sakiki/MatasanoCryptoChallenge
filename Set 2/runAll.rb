#!/usr/bin/ruby

# Run all Set 2
Dir.chdir Dir.pwd
(9..16).each do |i|
	command = "ruby Challenge" + i.to_s + ".rb"
	system command
	
	gets
	
	
end