org 0x7c00
jmp 0x0000:start


data:
yellow db 'amarelo', 0
blue db 'azul', 0
green db 'verde', 0
red db 'vermelho', 0
false db 'nao existe', 0
string times 10 db 0

endl:
  mov al, 0x0a          ; line feed
  call putchar
  mov al, 0x0d          ; carriage return
  call putchar
  ret

putchar:                              ; imprime caracter na tela
  mov ah, 0xe
  mov bh, 0
  mov bl, 0xf
  int 10h
  ret
  
getchar:                              ; lê caracter
  mov ah, 0x00
  int 16h
  ret

delchar:                              ; deleta caracter
  mov al, 0x08          ; backspace
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08          ; backspace
  call putchar
  ret

gets:                                 ; Função que recebe string / mov di, string
  xor cx, cx          ; zerar contador
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    cmp cl, 10        ; string limit checker
    je .loop1
    
    stosb
    inc cl
    mov ah, 0xe
    mov bh, 0
    mov bl, 0xe
    call putchar
    
    jmp .loop1
    .backspace:
      cmp cl, 0       ; is empty?
      je .loop1
      dec di
      dec cl
      mov byte[di], 0
      call delchar
    jmp .loop1
  .done:
  mov al, 0
  stosb
  call endl
  ret

strcmp:                               ; Compara strings / mov si, string1, mov di, string2
  .loop1:
    lodsb
    cmp al, byte[di]
    jne .notequal
    cmp al, 0
    je .equal
    inc di
    jmp .loop1
  .notequal:
    clc
    ret
  .equal:
    stc
    ret

compare_yellow:                       ; Verifica se a string lida é amarela, caso não seja chama a função para verificar se ela é azul
    mov si, string
    mov di, yellow
    .loop1:
        lodsb
        cmp al, byte[di]
        jne .notequal
        cmp al, 0
        je .equal
        inc di
        jmp .loop1
    .notequal:
        clc
        call compare_blue
        ret
    .equal:
        stc
        call intela
        mov si, yellow
        .loop:
            lodsb
            cmp al, 0
            je endP
            sub al, 32
            mov ah, 0xe
            mov bh, 0
            mov bl, 0xe
            int 10h
            jmp .loop
            ret
        
compare_blue:                         ; Verifica se a string recebida é azul, caso contrario chama a função para verificar se ela é verde
    mov si, string
    mov di, blue
    .loop1:
        lodsb
        cmp al, byte[di]
        jne .notequal
        cmp al, 0
        je .equal
        inc di
        jmp .loop1
    .notequal:
        clc
        call compare_green
        ret
    .equal:
        stc
        mov si, blue
        call intela
        .loop:
            lodsb
            cmp al, 0
            je endP
            sub al, 32
            mov ah, 0xe
            mov bh, 0
            mov bl, 1
            int 10h
            jmp .loop
            ret

compare_green:                        ; Verifica se a string recebida é verda, caso contrário chama a função para verificar se ela é verde
    mov si, string
    mov di, green
    .loop1:
        lodsb
        cmp al, byte[di]
        jne .notequal
        cmp al, 0
        je .equal
        inc di
        jmp .loop1
    .notequal:
        clc
        call compare_red
        ret
    .equal:
        stc
        mov si, green
        call intela
        .loop:
            lodsb
            cmp al, 0
            je endP
            sub al, 32
            mov ah, 0xe
            mov bh, 0
            mov bl, 0xa
            int 10h
            jmp .loop
            ret

compare_red:                          ; Verifica se a string recebida é vermelha, caso contrário imprime que NÃO EXISTE
    mov si, string
    mov di, red
    .loop1:
        lodsb
        cmp al, byte[di]
        jne .notequal
        cmp al, 0
        je .equal
        inc di
        jmp .loop1
    .notequal:
        clc
        call falseT
    .equal:
        stc
        mov si, red
        call intela
        .loop:
            lodsb
            cmp al, 0
            je endP
            sub al, 32
            mov ah, 0xe
            mov bh, 0
            mov bl, 0xc
            int 10h
            jmp .loop
            ret


falseT:                               ; Função que printa a string false
  mov si, false
  call intela
    .loopF:
        lodsb
        cmp al, 0
        je endP
        sub al, 32
        mov ah, 0xe
        mov bh, 0
        mov bl, 5
        int 10h
        jmp .loopF
        
        ret

intela:                               ; Função que incia o modo video e printa uma tela preta pra carregar as cores
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

endP:                                 ; Função que termina o programa
  jmp $

start:                                ; main
    xor ax, ax
    mov ds, ax
    mov es, ax
    call intela
    mov di, string
    call gets
    call compare_yellow 

times 510 - ($-$$) db 0
dw 0xaa55
