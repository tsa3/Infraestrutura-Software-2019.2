;Jogo do Labirinto: Adventure Bit
org 0x7E00
jmp 0x0000:start

;Titulo e Menu
title db 'Adventure Bit', 13
begin db 'Play', 13
guide db 'Guide', 13
credits db 'Credits', 13
press_enter db 'Please, press enter to retorne to the menu', 13

;Regras
instruction             db 'The objective of the game is find the smallest way to get out of the maze', 13
instructions_to_play    db 'How to play', 13
up                      db 'W - Up', 13
down                    db 'S - Down', 13
left                    db 'A - Left', 13
right                   db 'D - right', 13
ahac			db 'Arthur Henrique - ahac', 13
jpspm			db 'Joao Pedro      - jpspm', 13
tsa3			db 'Thiago Araujo   - tsa3', 13

start:
    mov ah, 0
    mov al, 12h
    int 10h

    call telainicial

    jmp exit
colorscreen:
    ;Colorindo a tela
    mov ah, 0xb
    mov bh, 0
    mov bl, 4
    int 10h
    ret
telainicial:
    call colorscreen

    ;Setando o cursor
    mov ah, 02h
    mov bh, 00h
    mov dh, 07h
    mov dl, 20h
    int 10h

    ;Printando Título
    mov si, title
    call print_parts

    ;Chama o menu
    call menu

    ;Verifica se foi selecionado as regras
    cmp cx, 2
    je rules

    ;Inicia o jogo, vai para o kernel
    call jogo

    ;Printa a string
    print_parts:
        lodsb
        mov ah, 0xe
        mov bh, 0
        mov bl, 0xf
        int 10h

        call delay

        cmp al, 13
        jne print_parts
        ret

    ;Imprime as regras do jogo
    rules:

        ;Modo vga
        mov ah, 0
        mov al, 12h
        int 10h

        ;Muda cor da tela
        call colorscreen
        ;Setando o cursor
        mov ah, 02h
        mov bh, 00h
        mov dh, 02h
        mov dl, 07h
        int 10h

        ;Imprime Guide
        mov ah, 0xf
        mov bl, 0xf
        mov si, guide
        call prints
        call endl

        ;Imprime Instruções
        mov ah, 02h
        mov bh, 00h
        mov dh, 03h
        mov dl, 07h
        mov bl, 0xf
        int 10h
        mov si, instruction
        call prints
        call endl

        ;Imprime Comandos
        mov ah, 02h
        mov bh, 00h
        mov dh, 06h
        mov dl, 07h
        int 10h
        mov si, instructions_to_play
        call prints
        call endl

        ;W
        mov ah, 02h
        mov bh, 00h
        mov dh, 07h
        mov dl, 07h
        int 10h
        mov si, up
        call prints
        call endl

        ;S
        mov ah, 02h
        mov bh, 00h
        mov dh, 08h
        mov dl, 07h
        int 10h
        mov si, down
        call prints
        call endl

        ;A
        mov ah, 02h
        mov bh, 00h
        mov dh, 09h
        mov dl, 07h
        int 10h
        mov si, left
        call prints
        call endl

        ;D
        mov ah, 02h
        mov bh, 00h
        mov dh, 10
        mov dl, 07h
        int 10h
        mov si, right
        call prints
        call endl

        ;Credits
        mov ah, 02h
        mov bh, 00h
        mov dh, 12h
        mov dl, 07h
        int 10h
        mov si, credits
        call prints
        call endl

        ;a
        mov ah, 02h
        mov bh, 00h
        mov dh, 13h
        mov dl, 07h
        int 10h
        mov si, ahac
        call prints
        call endl

        ;j
        mov ah, 02h
        mov bh, 00h
        mov dh, 14h
        mov dl, 07h
        int 10h
        mov si, jpspm
        call prints
        call endl

        ;t
        mov ah, 02h
        mov bh, 00h
        mov dh, 15h
        mov dl, 07h
        int 10h
        mov si, tsa3
        call prints
        call endl

        ;pres_enter
        mov ah, 02h
        mov bh, 00h
        mov dh, 19h
        mov dl, 14h
        int 10h
        mov si, press_enter
        call prints
        call endl
        
        wait_return:
            mov ah, 0
            int 16h

            cmp al, 13
            jne wait_return

        call start
        ret

menu:
    ;Inicia tela
    mov ah, 02h
    mov bh, 00h
    mov dh, 10h
    mov dl, 10h
    int 10h

    ;Imprime onde o local que o cursor se encontra
	mov ah, 0xe
	mov al, '>'
	mov bh, 0
	mov bl, 0xf
	int 10h

    ;Imprime Start
    mov si, begin
    call prints

    ;Modifica a posição do cursor
    mov ah, 02h
    mov bh, 00h
    mov dh, 12h
    mov dl, 11h
    int 10h

    ;Imprime Guide
    mov si, guide
    call prints

    ;Coloca a posição do cursor com 1
    mov cx, 1
    call change_cursor

    ;Retorna
    ret

change_cursor:
    mov ah, 0
    int 16h

    cmp al, 's'
    je baixo

    cmp al, 'w'
    je cima

    cmp al, 13
    jne change_cursor

    ret

    baixo:
        cmp cx, 2
        je cima

        mov ah, 02h
        mov bh, 00h
        mov dh, 10h
        mov dl, 10h
        int 10h

        mov ah, 0xe
        mov al, 0
        mov bh, 0
        mov bl, 0xf
        int 10h

        mov ah, 02h
        mov bh, 00h
        mov dh, 12h
        mov dl, 10h
        int 10h

        mov ah, 0xe
        mov al, '>'
        mov bh, 0
        mov bl, 0xf
        int 10h

        mov cx, 2
        jmp change_cursor
    
    cima:
        cmp cx, 1
        je baixo

        mov ah, 02h
        mov bh, 00h
        mov dh, 10h
        mov dl, 10h
        int 10h
        
        mov ah, 0xe
        mov al, '>'
        mov bh, 0
        mov bl, 0xf
        int 10h

        mov ah, 02h
        mov bh, 00h
        mov dh, 12h
        mov dl, 10h
        int 10h

        mov ah, 0xe
        mov al, 0
        mov bh, 0
        mov bl, 0xf
        int 10h

        mov cx, 1
        jmp change_cursor

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
    mov al, 0x0a            
    call putchar
    mov al, 0x0d           
    call putchar
    ret

prints:
    lodsb 

    mov ah, 0xe
    mov bh, 0
    int 10h

    cmp al, 13
    jne prints

    ret

jogo:
;Setando a posição do disco onde kernel.asm foi armazenado(ES:BX = [0x500:0x0])
    ;0x50<<1 + 0 = 0x500
	mov ax,0x860		
	mov es,ax
    ;Zerando o offset
	xor bx,bx		

;Setando a posição da Ram onde o jogo será lido
    ;comando de ler setor do disco
	mov ah, 0x02	
    ;quantidade de blocos ocupados por jogo
	mov al,8		
    ;drive floppy
	mov dl,0		

;Usaremos as seguintes posições na memoria:
    ;trilha 0
	mov ch,0		
    ;setor 2
	mov cl,7		
    ;cabeca 0
	mov dh,0		
	int 13h
	jc jogo	
;Pula para a posição do kernel
break:	
	jmp 0x8600 		        

exit:
