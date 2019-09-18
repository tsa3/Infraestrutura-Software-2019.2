org 0x8600
jmp 0x0000:start
;342
data:
	map db  8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,2,8,-1,8,15,15,7,7,15,15,15,15,15,7,15,7,7,15,7,15,15,15,15,15,7,7,15,8,-1,8,15,7,7,7,15,7,7,7,15,7,15,15,15,15,15,15,7,7,7,7,7,7,15,8,-1,8,15,15,15,15,15,15,15,7,15,7,15,7,7,7,7,15,7,7,15,15,15,15,15,8,-1,8,15,7,7,7,7,7,7,7,7,7,15,15,15,7,7,15,15,15,15,7,7,7,7,8,-1,8,15,7,7,15,15,15,15,15,7,7,15,7,7,7,7,7,7,7,7,7,7,15,15,8,-1,8,15,7,7,15,7,7,7,15,7,7,15,15,15,15,15,7,7,15,15,15,15,15,7,8,-1,8,15,15,15,15,7,7,15,15,15,7,7,7,7,7,15,7,7,15,7,7,7,15,7,8,-1,8,7,7,7,15,7,7,7,7,15,15,15,15,15,7,15,15,15,15,7,15,7,15,7,8,-1,8,7,15,15,15,15,15,15,7,7,15,7,7,7,7,7,7,7,7,7,15,7,15,7,8,-1,8,15,15,7,7,7,7,15,15,7,15,15,15,15,15,15,15,15,15,15,15,15,15,7,8,-1,8,7,15,15,15,15,7,7,15,7,7,7,7,7,7,7,7,15,7,7,7,7,7,7,8,-1,8,7,7,7,7,15,7,7,15,15,15,15,15,15,15,7,7,15,7,15,15,15,15,7,8,-1,8,7,7,15,15,15,15,15,15,7,7,7,7,7,15,7,7,7,7,15,7,7,7,7,8,-1,8,7,7,15,7,7,7,7,15,7,7,15,7,7,15,15,15,15,15,15,15,15,7,15,8,-1,8,15,15,15,7,7,7,7,15,7,7,15,15,7,7,7,7,7,7,7,7,15,7,15,8,-1,8,15,7,15,15,15,15,15,15,7,7,7,15,15,15,15,15,15,15,15,7,7,7,15,8,-1,8,15,7,7,15,7,7,7,15,15,15,15,15,7,7,15,7,7,7,15,15,15,15,15,8,-1,8,4,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,-2
	
	caracter db 1
	clear db 15

	linha dw 0
	coluna dw 0
	limitelinha dw 25
	limitecoluna dw 25

	personagemx dw 25
	personagemy dw 425
	limPerX dw 50
	limPerY dw 450

	coisinha dw 0
	posicao dw 443

	win db 'Congratulations!!! You win the game!', 13

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
	mov bl, [si]
	int 10h
	ret

drawImg: ;antes de usar, precisamos dizer quem s1 vai pegar
	mov dx, [coluna] ; recebe o valor da coluna
	.for1: 
		cmp dl, [limitecoluna] ;cmpara se esta no limite
		je .endfor1
		mov cx, [linha] ; mov o valor da posiçao linha
		.for2:
			cmp cl, [limitelinha] ; compara se esta no limite
			je .endfor2
			call writePixel
			inc cx
			jmp .for2
		.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret

printar:
	mov si, map
	.loop:
		mov al, [si]
		cmp al, -2 ; compara o valor de si, -2 acaba a a matriz
		je .fim
		cmp al, -1 ;se for -1 pula linha
		je .pula
		call drawImg ; chama a função que pinta o pixal
		inc si
		mov bx, [linha] ; move o calor de linha pra bx
		add bx, 25 ;soma 25
		mov word[linha], bx ;volta o valor somado
		mov bx, [limitelinha] ;move o vlor de limite linha pra bx
		add bx, 25 ;soma 25
		mov word[limitelinha], bx ;volta o valor somado
		jmp .loop
	.pula:
		mov bx, [coluna] ;move o valor de coluna pra bx
		add bx, 25 ;soma 25
		mov word[coluna], bx ;passa o valor somado, pra incrementar o valor da coluna
		mov bx, [limitecoluna] ; passa o valor de limite coluna pra bx
		add bx, 25 ;soma 25
		mov word[limitecoluna], bx ; passa o valor somado
		mov bx, 0 ;zera bx
		mov word[linha], bx ;passa o valor zero pra linha, pq quando pula linha tem q setar em 0 o valor do cursor
		mov bx, 25
		mov word[limitelinha], bx
		inc si
		jmp .loop
	.fim:
		ret
		
printarpers:
	mov dx, [personagemy] ; recebe o valor da coluna
	.for1: 
		cmp dl, [limPerY] ;cmpara se esta no limite
		je .endfor1
		mov cx, [personagemx] ; mov o valor da posiçao linha
		.for2:
			cmp cl, [limPerX] ; compara se esta no limite
			je .endfor2
			call writePixel
			inc cx
			jmp .for2
		.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret



movpers:
	.loop:
		mov si, map
		mov bx, word[posicao]
		add si, bx
		mov di, si
		mov al, [si]
		cmp al, 2
		je .victory
		xor ax, ax
		mov ah, 0 ;Número da chamada.
		int 16h
		cmp al, 'w'
		je .up
		cmp al, 's'
		je .down
		cmp al, 'a'
		je .left
		cmp al, 'd'
		je .right
		jmp .loop
	.up:
		mov bx, si
		sub bx, 26
		mov si, bx
		mov al, byte[si]
		cmp al, 15
		je .validaUp
		cmp al, 2
		je .victory
		mov si, di
		jmp .loop
	.down:
		mov bx, si
		add bx, 26
		mov si, bx
		mov al, byte[si]
		cmp al, 15
		je .validadown
		mov si, di
		jmp .loop
	.left:
		mov bx, si
		sub bx, 1
		mov si, bx
		mov al, byte[si]
		cmp al, 15
		je .validaleft
		mov si, di
		jmp .loop
	.right:
		mov bx, si
		add bx, 1
		mov si, bx
		mov al, byte[si]
		cmp al, 15
		je .validaright
		mov si, di
		jmp .loop
	.validaUp:
		mov si, clear
		call printarpers
		mov bx, word[personagemy]
		sub bx, 25
		mov word[personagemy], bx
		mov bx, word[limPerY]
		sub bx, 25
		mov word[limPerY], bx
		xor ax, ax
		mov ax, [caracter]
		mov si, ax
		call printarpers
		mov ax, 0
		mov ax, 26
		mov bx, word[posicao]
		sub bx, ax
		mov word[posicao], bx
		jmp .loop

	.validadown:
		mov si, clear
		call printarpers
		mov bx, word[personagemy]
		add bx, 25
		mov word[personagemy], bx
		mov bx, word[limPerY]
		add bx, 25
		mov word[limPerY], bx
		xor ax, ax
		mov ax, [caracter]
		mov si, ax
		call printarpers
		mov ax, 0
		mov ax, 26
		mov bx, word[posicao]
		add bx, ax
		mov word[posicao], bx
		jmp .loop

	.validaleft:
		mov si, clear
		call printarpers
		mov bx, word[personagemx]
		sub bx, 25
		mov word[personagemx], bx
		mov bx, word[limPerX]
		sub bx, 25
		mov word[limPerX], bx
		xor ax, ax
		mov ax, [caracter]
		mov si, ax
		call printarpers
		mov ax, 0
		mov ax, 1
		mov bx, word[posicao]
		sub bx, ax
		mov word[posicao], bx
		jmp .loop
	.validaright:
		mov si, clear
		call printarpers
		mov bx, word[personagemx]
		add bx, 25
		mov word[personagemx], bx
		mov bx, word[limPerX]
		add bx, 25
		mov word[limPerX], bx
		xor ax, ax
		mov ax, [caracter]
		mov si, ax
		call printarpers
		mov ax, 0
		mov ax, 1
		mov bx, word[posicao]
		add bx, ax
		mov word[posicao], bx
		jmp .loop
.victory:
	call intela
	mov ah, 0xb
    mov bh, 0
    mov bl, 4
    int 10h
	mov si, win
	;Muda a posição onde a string será printada
	mov ah, 02h
	mov bh, 00h
	mov dh, 14
	mov dl, 14h
	int 10h
	;Printa a string
	call .prints
    call .wait_return
	jmp 0x7E00
	.prints:
		lodsb 

		mov ah, 0xe
		mov bh, 0
		mov bl, 0xf
		int 10h

		cmp al, 13
		jne .prints

		ret
	.wait_return:
		mov ah, 0
		int 16h

		cmp al, 13
		jne .wait_return
		
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
	call printar
	mov si, caracter
	call printarpers
	call movpers

exit:
	jmp 0x7E00