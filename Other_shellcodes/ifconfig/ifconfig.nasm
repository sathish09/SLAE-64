section .text
        global _start
         
    _start:
        xor     rax, rax
        push    rax
        push    0x30687465
        mov     rcx, rsp
        
        
        mov     rbx, 0x6769666e6f63ffff
        shr     rbx, 0x10
        push    rbx
        mov     rbx, 0x66692f6e6962732f 
        push    rbx
        mov     rdi, rsp
         
        push    rax
        push    rcx
        push    rdi
        mov     rsi, rsp
         
        mov     al, 0x3b
        syscall
