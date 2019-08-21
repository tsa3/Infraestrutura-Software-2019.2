org 0x7c00
jmp 0x0000:start

data:
    first times 32 db 0
    second times 48 db 0
putchar:                ; mostra caracter no video
  mov ah, 0x0e
  int 10h
  ret
  
getchar:                ; recebe caracter do teclado
  mov ah, 0x00
  int 16h
  ret
  
delchar:                ; deleta um caracter
  mov al, 0x08          
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08
  call putchar
  ret
  
endl:                   ; pula linha
  mov al, 0x0a
  call putchar
  mov al, 0x0d
  call putchar
  ret
strcmp:                 ; Compara strings / mov di, string1, mov si, string2
    .loop1:
    lodsb
    cmp al, byte[di]    ; String1 é a menor terá o di apontando, já a String2 que é a maior terá o si apontando
    jne .notequal
    cmp al, 0
    je .equal
    inc di              ; Só ocorre o incremento de di se o valor os bits comparados forem iguais e não estiver acabado a String1
    jmp .loop1
    .notequal:          ; Quando o caracter não é igual ocorre o incremento de String2 e não ocorre o de String1
    clc
    cmp al, 0
    je .dont
    jne .loop1
    .equal:             ; Só será igual se a string1 for 0, já que ela só vai chegar no 0 se todas as letras delas existirem em String2
    cmp byte[di], 0
    je .yep             ; Caso a string1 esteja no 0 será printado sim
    jne .dont           ; Caso a string1 não tenha chegado no fim significa que String2 não contém ela e assim será printado não
    stc
    ret
    .dont:
        call dont
        jmp done
    .yep:
        call yep
        jmp done    
dont:                   ; imprime a resposta não
    call intela
    .print:
        mov al, 'n'
        mov ah, 0xe
        mov bl, 15
        int 10h
        cmp al, 0
        je done
        mov al, 'a'
        mov ah, 0xe
        mov bl, 15
        int 10h
        mov al, 'o'
        mov ah, 0xe
        mov bl, 15
        int 10h
        ret
yep:                   ; imprime a resposta sim
    call intela
    .print:
        mov al, 's'
        mov ah, 0xe
        mov bl, 15
        int 10h
        cmp al, 0
        je done
        mov al, 'i'
        mov ah, 0xe
        mov bl, 15
        int 10h
        mov al, 'm'
        mov ah, 0xe
        mov bl, 15
        int 10h
        ret  
gets:                   ; Função que recebe string / mov di, string
  xor cx, cx        
  .loop1:
    call getchar
    cmp al, 0x08
    je .backspace
    cmp al, 0x0d
    je .done
    
    stosb
    inc cl
    mov ah, 0xe
    mov bh, 0
    mov bl, 15       
    call putchar
    
    jmp .loop1
    .backspace:
      cmp cl, 0
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
intela:                ; Função que incia o modo video e printa uma tela preta pra carregar as cores
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

start:                 ; inicio da questão
    xor ax, ax
    mov ds, ax
    mov es, ax
    call intela
    mov di, first
    call gets
    mov di, second
    call gets
    mov di, first
    mov si, second
    call strcmp
    call done
done:                  ; finaliza o programa
    jmp $

times 510 - ($-$$) db 0
dw 0xaa55