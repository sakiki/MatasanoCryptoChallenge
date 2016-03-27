#!/usr/bin/ruby

# Set 3 - Challenge 17
# The CBC padding oracle

require './set3Lib.rb'

consistentKey = randomAESKey16

cbcPaddingArry = cbcPaddingOracleEncrypt(consistentKey)
ivUsed = cbcPaddingArry[0]
ct = cbcPaddingArry[1]

# Here is the logic:

# It is easiest to think of this two blocks at a time.

# The first block is getting XOR'd with the decrypted intermediate 
# state of the second one.  The key to this attack is that we know the plain text
# and can modify the first block to find the intermediate states.

# Recall:
# INTERMEDIATE_STATE = PLAINTEXT XOR CIPHERTEXT(N-1)

# and therefore

# PLAINTEXT = CIPHERTEXT(N-1) XOR INTERMEDIATE_STATE

# We must first find the intermediate state of the last byte of plaintext.  Since we know 
# that valid padding only occurs when the last byte is \x01, we cycle through ATTACK_STR(N-1)[15]
# values as the first block until we validate the padding.  ATTACK_STR is 16 bytes in length and 
# the other values can be random.  Therefore we have the last byte of the intermediate state:

# INTERMEDIATE_STATE[15] = 01 XOR ATTACK_STR(N-1)[15]

# This INTERMEDIATE_STATE[15] byte can be XOR'd with the CIPHERTEXT(N-1)[15] byte to find the real 
# value of CIPHERTEXT(N)[15]!

# For the next byte we must realize that the plain text for the last two bytes of the PLAINTEXT
# will be \x02.  We know the intermediate state for the last byte but not the second-to-last byte.
# To find it, we construct an "attack block" with 14 random values (1 less than last time), our 
# unknown value and the previous INTERMEDIATE_STATE byte XOR'd with 02.

# When we validate we know that:

# INTERMEDIATE_STATE[14] = 02 XOR ATTACK_STR(N-1)[14]

# We can then take INTERMEDIATE_STATE[14] and XOR it with CIPHERTEXT(N-1)[14] to find the real value 
# of CIPHERTEXT(N)[14]!

# Continue until you are done with the block

puts cbcPaddingOracleAttack(ivUsed, ct, consistentKey)


