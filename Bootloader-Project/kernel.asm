org 0x8600
jmp 0x0000:start
;Data of game
data:
	;vector map from the game
	map db  8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,2,8,-1,8,15,15,7,7,15,15,15,15,15,7,15,7,7,15,7,15,15,15,15,15,7,7,15,8,-1,8,15,7,7,7,15,7,7,7,15,7,15,15,15,15,15,15,7,7,7,7,7,7,15,8,-1,8,15,15,15,15,15,15,15,7,15,7,15,7,7,7,7,15,7,7,15,15,15,15,15,8,-1,8,15,7,7,7,7,7,7,7,7,7,15,15,15,7,7,15,15,15,15,7,7,7,7,8,-1,8,15,7,7,15,15,15,15,15,7,7,15,7,7,7,7,7,7,7,7,7,7,15,15,8,-1,8,15,7,7,15,7,7,7,15,7,7,15,15,15,15,15,7,7,15,15,15,15,15,7,8,-1,8,15,15,15,15,7,7,15,15,15,7,7,7,7,7,15,7,7,15,7,7,7,15,7,8,-1,8,7,7,7,15,7,7,7,7,15,15,15,15,15,7,15,15,15,15,7,15,7,15,7,8,-1,8,7,15,15,15,15,15,15,7,7,15,7,7,7,7,7,7,7,7,7,15,7,15,7,8,-1,8,15,15,7,7,7,7,15,15,7,15,15,15,15,15,15,15,15,15,15,15,15,15,7,8,-1,8,7,15,15,15,15,7,7,15,7,7,7,7,7,7,7,7,15,7,7,7,7,7,7,8,-1,8,7,7,7,7,15,7,7,15,15,15,15,15,15,15,7,7,15,7,15,15,15,15,7,8,-1,8,7,7,15,15,15,15,15,15,7,7,7,7,7,15,7,7,7,7,15,7,7,7,7,8,-1,8,7,7,15,7,7,7,7,15,7,7,15,7,7,15,15,15,15,15,15,15,15,7,15,8,-1,8,15,15,15,7,7,7,7,15,7,7,15,15,7,7,7,7,7,7,7,7,15,7,15,8,-1,8,15,7,15,15,15,15,15,15,7,7,7,15,15,15,15,15,15,15,15,7,7,7,15,8,-1,8,15,7,7,15,7,7,7,15,15,15,15,15,7,7,15,7,7,7,15,15,15,15,15,8,-1,8,4,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,-2
	;vector caracter from the game
	caracter db 1
	clear db 15
	;limits
	linha dw 0
	coluna dw 0
	limitelinha dw 25
	limitecoluna dw 25
	;caracter cordenation
	personagemx dw 25
	personagemy dw 425
	limPerX dw 50
	limPerY dw 450
	;begin position
	coisinha dw 0
	posicao dw 443
	;condition to win, if was bigger the player lose the game
	limit_win dw 85
	count dw 0
	;message when the player win the game
	win db 'Congratulations!!! You win the game!', 13
	;message when the player lose the game
	lose db 'You lose the game! The limit of steps was exceeded', 13
	;message to press enter
	press_enter db 'Please, press enter to retorne to the menu', 13
;Function to start the screem in vga mode and video mode
intela:                               
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
;Fuction to write the pixel
writePixel:
	mov ah, 0ch
	mov bl, [si]
	int 10h
	ret
;Function to draw the map
drawImg:
	mov dx, [coluna]
	.for1: 
		;if dl == limitecoluna, then finish
		cmp dl, [limitecoluna] 
		je .endfor1
		;update line value
		mov cx, [linha]
		.for2:
			;if cl == limitelinha, then the draw was done
			cmp cl, [limitelinha]
			je .endfor2
			call writePixel
			inc cx
			jmp .for2
		.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret
;Function to print the map
printar:
	mov si, map
	.loop:
		mov al, [si]
		;if al == 2, then matrix finish
		cmp al, -2
		je .fim
		;if al == -1, then jump the line
		cmp al, -1
		je .pula
		call drawImg
		inc si
		;mov line to bx
		mov bx, [linha]
		add bx, 25 
		;update the new value for the line
		mov word[linha], bx
		;mov limiteLinhas to bx
		mov bx, [limitelinha] 
		add bx, 25 
		;update the limit value for the line
		mov word[limitelinha], bx
		jmp .loop
	.pula:
		;mov coluna value to bx
		mov bx, [coluna]
		add bx, 25
		;update the colune value
		mov word[coluna], bx
		;mov limitecoluna to bx
		mov bx, [limitecoluna]
		add bx, 25
		;update the limitecoluna value
		mov word[limitecoluna], bx
		mov bx, 0
		;the new line has 0 value, because the jump line
		mov word[linha], bx
		mov bx, 25
		mov word[limitelinha], bx
		inc si
		jmp .loop
	.fim:
		ret
;Function to print hte caracter
printarpers:
	;Give  the cordenate y for the caracter to dx
	mov dx, [personagemy]
	.for1: 
		;If dl == limitey, then finish
		cmp dl, [limPerY]
		je .endfor1
		;update the new line
		mov cx, [personagemx]
		.for2:
			;if dl == li, then jump line
			cmp cl, [limPerX]
			je .endfor2
			call writePixel
			inc cx
			jmp .for2
		.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret
;The rules for the caracter moviment
movpers:
	.loop:
		mov si, map
		mov bx, word[posicao]
		add si, bx
		mov di, si
		;al mov [si], receive the value 
		mov al, [si]
		;if al == 2, then you win
		cmp al, 2
		je .victory
		mov bx, word[count]
		;if bx == limit_win, then the steps form outdated
		cmp bx, [limit_win]
		je .loser
		;check if the keybord was press
		xor ax, ax
		mov ah, 0 
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
	;check if is possible the moviment up
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
	;check if is possible the moviment down
	.down:
		mov bx, si
		add bx, 26
		mov si, bx
		mov al, byte[si]
		cmp al, 15
		je .validadown
		mov si, di
		jmp .loop
	;check if is possible the moviment left
	.left:
		mov bx, si
		sub bx, 1
		mov si, bx
		mov al, byte[si]
		cmp al, 15
		je .validaleft
		mov si, di
		jmp .loop
	;check if is possible the moviment right
	.right:
		mov bx, si
		add bx, 1
		mov si, bx
		mov al, byte[si]
		cmp al, 15
		je .validaright
		mov si, di
		jmp .loop
	;Execute moviment up
	.validaUp:
		;count one step
		mov bx, word[count]
		add bx, 1
		mov word[count], bx
		;clear the last position
		mov si, clear
		call printarpers
		;update the values
		mov bx, word[personagemy]
		sub bx, 25
		mov word[personagemy], bx
		mov bx, word[limPerY]
		sub bx, 25
		mov word[limPerY], bx
		xor ax, ax
		mov ax, [caracter]
		mov si, ax
		;print the new position
		call printarpers
		mov ax, 0
		mov ax, 26
		mov bx, word[posicao]
		sub bx, ax
		mov word[posicao], bx
		jmp .loop
	;Execute moviment down
	.validadown:
		;count one step
		mov bx, word[count]
		add bx, 1
		mov word[count], bx
		;clear the last position
		mov si, clear
		call printarpers
		;update the values
		mov bx, word[personagemy]
		add bx, 25
		mov word[personagemy], bx
		mov bx, word[limPerY]
		add bx, 25
		mov word[limPerY], bx
		xor ax, ax
		mov ax, [caracter]
		mov si, ax
		;print the new position
		call printarpers
		mov ax, 0
		mov ax, 26
		mov bx, word[posicao]
		add bx, ax
		mov word[posicao], bx
		jmp .loop
	;Execute moviment left
	.validaleft:
		;count one step
		mov bx, word[count]
		add bx, 1
		mov word[count], bx
		;clear the last position
		mov si, clear
		call printarpers
		mov bx, word[personagemx]
		sub bx, 25
		;update the values
		mov word[personagemx], bx
		mov bx, word[limPerX]
		sub bx, 25
		mov word[limPerX], bx
		xor ax, ax
		mov ax, [caracter]
		mov si, ax
		;print the new position
		call printarpers
		mov ax, 0
		mov ax, 1
		mov bx, word[posicao]
		sub bx, ax
		mov word[posicao], bx
		jmp .loop
	;Execute moviment right
	.validaright:
		;count one step
		mov bx, word[count]
		add bx, 1
		mov word[count], bx
		;clear the last position
		mov si, clear
		call printarpers
		;update the values
		mov bx, word[personagemx]
		add bx, 25
		mov word[personagemx], bx
		mov bx, word[limPerX]
		add bx, 25
		mov word[limPerX], bx
		xor ax, ax
		mov ax, [caracter]
		mov si, ax
		;print the new position
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
			mov dl, 17h
			int 10h
			;Printa a string
			call .prints
			mov si, press_enter
			;Muda a posição onde a string será printada
		    mov ah, 02h
			mov bh, 00h
			mov dh, 19h
			mov dl, 14h
			int 10h
			;Printa a string
			call .prints
    		call .wait_return
			ret
		.loser:
		    call intela
		    mov ah, 0xb
		    mov bh, 0
		    mov bl, 4
		    int 10h
		    mov si, lose
		    ;Muda a posição onde a string será printada
		    mov ah, 02h
			mov bh, 00h
			mov dh, 14
			mov dl, 11h
			int 10h
			;Printa a string
			call .prints
			mov si, press_enter
			;Muda a posição onde a string será printada
		    mov ah, 02h
			mov bh, 00h
			mov dh, 19h
			mov dl, 14h
			int 10h
			;Printa a string
			call .prints

    		call .wait_return
			ret

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
;Begin the kernel
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
