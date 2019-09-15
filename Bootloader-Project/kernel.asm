org 0x8600
jmp 0x0000:start

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0
    mov al, 12h
    int 10h

    mov ah, 0xb
    mov bh, 0
    mov bl, 10
    int 10h


done:
jmp $