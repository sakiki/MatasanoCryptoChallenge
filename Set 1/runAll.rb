#!/usr/bin/ruby

# Run all Set 1
Dir.chdir Dir.pwd
(1..8).each do |i|
	command = "ruby Challenge" + i.to_s + ".rb"
	system command
	
	gets
	
	
end