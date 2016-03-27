#!/usr/bin/ruby

# Set 3 - Challenge 18
# Implement CTR, the stream cipher mode

require './set3Lib.rb'

ctrStr = "L77na/nrFsKvynd6HzOoG7GHTLXsTVu9qvY/2syLXzhPweyyMTJULu/6/kXX0KSvoOLSFQ==".unpack("m").join

nounce = "\0"*8

# We only use AES encryption in CTR mode no matter what the actual CTR operation...cool
# .. Wondering if you could use a hash like SHA256 in that case
puts aesCTROperation(ctrStr, nounce, "YELLOW SUBMARINE")





