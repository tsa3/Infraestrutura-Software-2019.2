;Jogo do Labirinto: Adventury Bit
org 0x7E00
jmp 0x0000:start

title db 'Adventure Bit', 13
start db 'Play', 13
guide db 'Guide', 13

;Regras
guide_title db '-----Guide-----', 13
instruction db 'O jogo consiste em percorrer o menor caminho para fugir do labirinto', 13
instructions_to_play db 'How to play', 13
how_play db 'W - Cima, S - Baixo, A - Esquerda, D - Direita', 13

start:
    mov ah, 0
    mov al, 12h
    int 10h

    call telainicial

    jmp exit

telainicial:
    ;Colorindo a tela
    mov ah, 0xb
    mov bh, 0
    mov bl, 0
    int 10h

    ;Setando o curso
    mov ah, 02h
    mov bh, 00h
    mov dh, 07h
    mov dl, 20h
    int 10h

    ;Printando Título
    mov si, title
    print_title:
        lodsb
        mov ah, 0xe
        mov bh, 0
        mov bl, 0xf
        int 10h

        call delay

        cmp al, 13
        jne print_title



    
delay:
	mov bp, 350
	mov dx, 350
	delay2:
		dec bp
		nop
		jnz delay2
	dec dx
	jnz delay2

ret

break:	
	jmp 0x8600 		;Pula para a posição carregada

exit: