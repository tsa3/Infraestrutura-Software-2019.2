org 0x8600
jmp 0x0000:start

data:
	map db  8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,4,8,-1,8,15,15,7,7,15,15,15,15,15,7,15,7,7,15,7,15,15,15,15,15,7,7,15,8,-1,8,15,7,7,7,15,7,7,7,15,7,15,15,15,15,15,15,7,7,7,7,7,7,15,8,-1,8,15,15,15,15,15,15,15,7,15,7,15,7,7,7,7,15,7,7,15,15,15,15,15,8,-1,8,15,7,7,7,7,7,7,7,7,7,15,15,15,7,7,15,15,15,15,7,7,7,7,8,-1,8,15,7,7,15,15,15,15,15,7,7,15,7,7,7,7,7,7,7,7,7,7,15,15,8,-1,8,15,7,7,15,7,7,7,15,7,7,15,15,15,15,15,7,7,15,15,15,15,15,7,8,-1,8,15,15,15,15,7,7,15,15,15,7,7,7,7,7,15,7,7,15,7,7,7,15,7,8,-1,8,7,7,7,15,7,7,7,7,15,15,15,15,15,7,15,15,15,15,7,15,7,15,7,8,-1,8,7,15,15,15,15,15,15,7,7,15,7,7,7,7,7,7,7,7,7,15,7,15,7,8,-1,8,15,15,7,7,7,7,15,15,7,15,15,15,15,15,15,15,15,15,15,15,15,15,7,8,-1,8,7,15,15,15,15,7,7,15,7,7,7,7,7,7,7,7,15,7,7,7,7,7,7,8,-1,8,7,7,7,7,15,7,7,15,15,15,15,15,15,15,7,7,15,7,15,15,15,15,7,8,-1,8,7,7,15,15,15,15,15,15,7,7,7,7,7,15,7,7,7,7,15,7,7,7,7,8,-1,8,7,7,15,7,7,7,7,15,7,7,15,7,7,15,15,15,15,15,15,15,15,7,15,8,-1,8,15,15,15,7,7,7,7,15,7,7,15,15,7,7,7,7,7,7,7,7,15,7,15,8,-1,8,15,7,15,15,15,15,15,15,7,7,7,15,15,15,15,15,15,15,15,7,7,7,15,8,-1,8,15,7,7,15,7,7,7,15,15,15,15,15,7,7,15,7,7,7,15,15,15,15,15,8,-1,8,2,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,-2

intela:                               ; Função que incia o modo vga e printa uma tela preta pra carregar as cores
    mov ah, 0
    mov al, 12h
    int 10h
    mov ah, 0xb
    mov al, 13h
    int 10h
    mov ah, 0xb
    mov bh, 0
    mov bl, 0
    int 10h
    ret

writePixel:
	mov ah, 0ch
	int 10h
	ret

drawMap:
		.loop:
			cmp si, -1
			je .jmpline
			cmp si, -2
			je .return
			cmp al, 8
			je .incSi
			jne .pAgain
		.paint:
			call writePixel
			add al, 1
			inc cx
			jmp .loop
		.pAgain:
			inc cx
			add al, 1
			call writePixel
			jmp .loop
		.jmpline:
			mov cx, 0
			inc dx
			cmp bl, 8
			je .nextReg
			jne .backReg
		.backReg:
			mov si, di
			add bl, 1
			jmp .loop
		.incSi:
			xor ax, ax
			inc si
			jmp .loop
		.nextReg:
			xor bx, bx
			xor ax, ax
			inc si
			mov di, si
			jmp .loop
		.return:
			xor ax, ax
	ret

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    call intela
	mov si, map
	mov di, map
	mov cx, 0
	mov dx, 0
    call drawMap

	jmp 0x8600

exit: