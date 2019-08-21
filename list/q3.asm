org 0x7c00
jmp 0x0000:start

data:
    qtd times 10 db 0
    string times 10 db 0
    sim db 'S', 0
    nao db 'N', 0

; funções
putchar:
    mov ah, 0x0e
    int 10h
    ret
  
getchar:
    mov ah, 0x00
    int 16h
    ret
  
gets:                 ; mov di, string
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

resolve:                                   ; adaptação da antiga gets, necessita de mov di, string
    xor cx, cx                          ; zerar contador
    .check:                             ; testar o contador, pra não ler mais do que a quantidade dada pela entrada
        cmp bl, 0
        dec bl
        jne .loop1
        je .done
        

    .loop1:
        call getchar
        cmp al, 0x08                    ; backspace
        je .backspace
        cmp al, 0x0d                    ; carriage return
        je .done
        cmp cl, 10                      ; string limit checker
        je .loop1

        stosb
        inc cl
        mov ah, 0xe
        mov bh, 0
        mov bl, 0xe
        call putchar

        pop dx                          ; remove a ponta da pilha
        cmp dl, 10                      ; checa se é o primeiro elemento da pilha
        je .back_to_stack                ; se for, devolve pra pilha
        
        add dl,2                        ; soma dois pra igualar [ com ] por exemplo já que [ = 133 e ] = 135 (ASCII)
        cmp al,dl                       ; compara eles dois para ver se são iguais, se forem, só deixa fora da pilha
        jne .check_parentesis           ; a diferença entre parentesis é um, já que ( = 50 e ) = 51 (ASCII)

        jmp .check

        .check_parentesis:              ; função pra checar parêntesis
        sub dl,1                        ; soma de volta 1
        cmp al,dl                       
        jne .back_to_stack              ; se não forem iguais, mandamos ambos de volta pra pilha
        je .check                       ; se sim, voltamos a rotina

        .back_to_stack:
        sub dl, 1                       ; dl volta ao valor inicial
        push dx
        push ax
        jmp .check

        .backspace:
        cmp cl, 0                       ; is empty?
        je .loop1
        dec di
        dec cl
        pop bx
        mov byte[di], 0
        call delchar
        jmp .loop1
    
    .done:
    mov al, 0
    stosb
    call endl
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

endP:                                   ; Função que termina o programa
    jmp $

print_S:
    mov si, sim
    call intela
    call prints
    ret

print_N:
    mov si, nao
    call intela
    .loop:
        lodsb
        cmp al, 0
        je endP
        mov ah, 0xe
        mov bh, 0
        mov bl, 0xe
        int 10h
        jmp .loop
        ret
    ret

prints:             ; mov si, string
  .loop:
    lodsb           ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret

start:                                  ; main
    xor ax, ax
    mov ds, ax
    mov es, ax
;#################                      ; recebendo o valor de entradas
    ;call intela
    mov di, qtd
    call gets
    mov di, string
    mov bl, al
    mov di, string
    call resolve
    pop dx
    cmp dl, 10
    je print_S
    jne print_N


times 510 - ($-$$) db 0
dw 0xaa55
