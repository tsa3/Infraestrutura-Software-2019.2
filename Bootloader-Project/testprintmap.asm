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
			cmp si, -1 ;se chega em -1 pula linha
			je .jmpline ; chama jump line
			cmp si, -2 ; se chegar em -2 acaba a matriz
			je .return ;chama a função de retorno
			jne .cmppx ;compara o pixel se for diferente de -2 e de -1
		.cmppx:
			cmp al,8 ;se chegou em 8
			jne .paint ;se nao chegou chama a funçao pra pintar
			je .nxtpx ;se chegou chama a next pixel
		.nxtpx:
			inc si ;incrementa si
			mov al, 0 ;zera o contador de vezes que o pixel foi printado
			jmp .loop ;volta pra loop

		.jmpline:
			cmp bl, 8 ;compara se printou a mesma linha 8 vezes
			je  .nextline ; se sim, vai pra proxima linha da matriz
			jne .backline ;se nao, volta pro começo da linha
		.nextline:
			inc si ;incrementa si pra sair de -1
			mov di, si ;muda o di pro começo da proxima linha
			inc dx ; incrementa dx pra pular linha no print
			mov cx, 0 ;volta cx pro começo pra voltar pro começo da linha pro print
			mov bl, 0 ;zera os contadores
			mov al, 0
			jmp .paint ; chama a funçao de print
		.backline:
			mov si,di ; volta o si pro começo da linha da matriz
			inc dx ;pula a linha do print
			add bl, 1 ; soma 1 no contador
			jmp .paint ;chama a função de print

		.paint:
			call writePixel ;chama a funçao de printar
			inc cx ;incrementa cx
			add al, 1 ;soma 1 no contador de repetiçao do pixel
			jmp .loop ;volta pra loop
		.return:
			mov al, 0 ;zera os contadores
			mov bl, 0 ;

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