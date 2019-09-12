;Jogo do Labirinto: Adventure Bit
org 0x7E00
jmp 0x0000:start

title db 'Adventure Bit', 13
start db 'Play', 13
guide db 'Guide', 13

;Regras
guide_title             db '-----Guide-----', 13
instruction             db 'O jogo consiste em percorrer o menor caminho para fugir do labirinto', 13
instructions_to_play    db 'How to play', 13
how_play                db 'W - Cima, S - Baixo, A - Esquerda, D - Direita', 13
start_game              db 'Press SPACE to start!', 13

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
    call print_parts
    call endl
    mov si, guide_title
    call print_parts
    call endl
    mov si, instruction
    call print_parts
    call endl
    mov si, instructions_to_play
    call print_parts
    call endl
    mov si, how_play
    call print_parts
    call endl


    
    print_parts:
        lodsb
        mov ah, 0xe
        mov bh, 0
        mov bl, 0xf
        int 10h

        call delay

        cmp al, 13
        jne print_parts


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

getchar:
    mov ah, 0x00
    int 16h
    ret

putchar:
    mov ah, 0x0e
    int 10h
    ret

endl:
    mov al, 0x0a            ; line feed
    call putchar
    mov al, 0x0d            ; carriage return
    call putchar
    ret

prints:                     ; mov si, string
  .loop:
    lodsb                   ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret

break:	
	jmp 0x8600 		        ; Pula para a posição carregada

exit:
    jmp 0x7e00              ; Começa o game {Posição de memória alocada para o Kernel}