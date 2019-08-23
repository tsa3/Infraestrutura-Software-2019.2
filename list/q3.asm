org 0x7c00
jmp 0x0000:start

data:
    qtd times 10 db 0
    string times 10 db 0
    sim db 'S', 0
    nao db 'N', 0
    contador times 16 db 0
; funções
putchar:
  mov ah, 0xe
  mov bh, 0
  mov bl, 0xf
  int 10h
  ret
  
getchar:
    mov ah, 0x00
    int 16h
    ret
  
gets:                                       ; mov di, string
  xor cx, cx          ; zerar contador
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    cmp cl, 20        ; string limit checker
    je .loop1
    
    stosb
    inc cl
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

delchar:
    mov al, 0x08                        ; backspace
    call putchar
    mov al, ' '
    call putchar
    mov al, 0x08                        ; backspace
    call putchar
    ret
  
endl:
    mov al, 0x0a                        ; line feed
    call putchar
    mov al, 0x0d                        ; carriage return
    call putchar
    ret

stoi:                                       ; mov si, string (String to integer)
  xor cx, cx
  xor ax, ax
  .loop1:
    push ax
    lodsb
    mov cl, al
    pop ax
    cmp cl, 0                               ; check EOF(NULL)
    je .endloop1
    sub cl, 48                              ; '9'-'0' = 9
    mov bx, 10
    mul bx                                  ; 999*10 = 9990
    add ax, cx                              ; 9990+9 = 9999
    jmp .loop1
  .endloop1:
  ret

resolve:                                    ; adaptação da antiga gets, necessita de mov di, string
    xor cx, cx                              ; zerar contador
    .check:                                 ; testar o contador, pra não ler mais do que a quantidade dada pela entrada
        cmp bx, 0
        je .done
        dec bl
        jne .loop1

    .loop1:
        call getchar
        cmp al, 0x08                        ; backspace
        je .backspace
        cmp ax, ' '                          ; compara com ' '
        je .loop1
        cmp cl, 30                          ; string limit checker
        je .loop1
        cmp al, 0x0d                        ; se a última tecla foi enter deve ir pra carregar resposta
        je .result

        stosb
        inc cl
        mov ah, 0xe
        mov bh, 0
        mov bl, 0xe
        call putchar

        ;pop dx                             ; remove a ponta da pilha
        ;cmp dx, 10                         ; checa se é o primeiro elemento da pilha
        ;je .take_it_back                   ; se for, devolve pra pilha
        
        cmp sp, 10                          ; compara o topo da pilha com 10
        jne .serase                           ; se o topo for 10, essa é a primeira interação
        pop ax

        .serase:
            pop dx
            add dl,2                            ; soma dois pra igualar [ com ] por exemplo já que [ = 133 e ] = 135 (ASCII)
            cmp al,dl                           ; compara eles dois para ver se são iguais, se forem, só deixa fora da pilha
            jne .check_parentesis               ; a diferença entre parentesis é um, já que ( = 50 e ) = 51 (ASCII)
            jmp .loop1

        .check_parentesis:                  ; função pra checar parêntesis
            sub dl,1                            ; soma de volta 1
            cmp al,dl                       
            jne .back_to_stack                  ; se não forem iguais, mandamos ambos de volta pra pilha
            je .loop1                           ; se sim, voltamos a rotina

        .take_it_back:
            push dx
            push ax
            jmp .loop1

        .back_to_stack:
            sub dl, 1                           ; dl volta ao valor inicial
            push dx                             ; devolve dx a pilha
            push ax                             ; inclui o ax na pilha
            jmp .loop1                          ; volta pra check

        .backspace:
            cmp cl, 0                           ; is empty?
            je .loop1   
            dec di
            dec cl
            pop bx
            mov byte[di], 0
            call delchar
            jmp .loop1
    
    .result:
        mov al, 0
        stosb
        pop dx
        cmp dx,10
        je .equal
        jne .not_equal
        call endl
        jmp .check

    .equal:
        mov si, sim
        call prints
        jmp .check
    
    .not_equal:
        mov si, nao
        call endl
        call prints
        call endl
        jmp .check

    .done:
        mov al, 0
        stosb
        call endl
        ret
        
intela:                                     ; Função que incia o modo video e printa uma tela preta pra carregar as cores
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

endP:                                       ; Função que termina o programa
    jmp $

prints:                                     ; mov si, string
  .loop:
    lodsb                                   ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret

start:                                      ; main
    xor ax, ax
    mov ds, ax
    mov es, ax
    ;adiciona 10 na pilha, pra ser o parametro de saber se tá vazia ou não
    add ax, 10
    pop ax
    xor ax, ax
    call intela
    ; recebendo o valor de entradas
    mov di, qtd
    call gets
    mov si, qtd
    call stoi
    ;ax = valor agora em inteiro
    mov bl, al                              ; bl = al
    mov si, string
    call resolve
    pop dx
    cmp dl, 10


times 510 - ($-$$) db 0
dw 0xaa55