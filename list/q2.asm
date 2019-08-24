org 0x7c00
jmp 0x0000:start

data:
    string1 times 10 db 0
    string2 times 10 db 0
    result times 10 db 0

putchar:
    mov ah, 0x0e
    int 10h
    ret
  
getchar:
    mov ah, 0x00
    int 16h
    ret
  
gets:                 ; mov di, string
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    
    stosb
    inc cl
    mov ah, 0xe
    mov bh, 0
    mov bl, 15

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

prints:             ; mov si, string
  .loop:
    lodsb           ; bota character em al 
    cmp al, 0
    je .endloop
    mov ah, 0xe
    mov bh, 0
    mov bl, 15
    call putchar
    jmp .loop
  .endloop:
    call endl
    ret

stoi:                ; mov si, string
  xor cx, cx
  xor ax, ax
  .loop1:
    push ax
    lodsb
    mov cl, al
    pop ax
    cmp cl, 0        ; check EOF(NULL)
    je .endloop1
    sub cl, 48       ; '9'-'0' = 9
    mov bx, 10
    mul bx           ; 999*10 = 9990
    add ax, cx       ; 9990+9 = 9999
    jmp .loop1
  .endloop1:
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

reverse:              ; mov si, string
  mov di, si
  xor cx, cx          ; zerar contador
  .loop1:             ; botar string na stack
    lodsb
    cmp al, 0
    je .endloop1
    inc cl
    push ax
    jmp .loop1
  .endloop1:
  .loop2:             ; remover string da stack        
    pop ax
    stosb
    loop .loop2
  ret

tostring:              ; mov ax, int / mov di, string
  push di
  .loop1:
    cmp ax, 0
    je .endloop1
    xor dx, dx
    mov bx, 10
    div bx            ; ax = 9999 -> ax = 999, dx = 9
    xchg ax, dx       ; swap ax, dx
    add ax, 48        ; 9 + '0' = '9'
    stosb
    xchg ax, dx
    jmp .loop1
  .endloop1:
  pop si
  cmp si, di
  jne .done
  mov al, 48
  stosb
  .done:
  mov al, 0
  stosb
  call reverse
  ret
  

gdc:
  pop ax ;Retira lixo da pilha
  pop cx
  pop bx
  cmp bx, cx
  je .equal
  cmp bx, cx
  jg .normal
  cmp bx, cx
  jl .change
  ret
    .loop:
      .equal:
        mov ax, cx
        mov di, result
        call tostring
        mov si, result
        call prints
        ret
      .normal:
        cmp bx, 1
        je .one_first
        cmp cx, 1
        je .one_second
        .loop_euclidian:
          push bx    
          push cx
          mov ax, bx ;dividento: ax | dividor: cx | quociente: ax | resto: dx
          mov dx, 0
          div cx
          pop bx
          mov cx, dx
          cmp cx, 0
          je .finish_rest_zero
          cmp cx, 1
          je .finish_rest_one
          jmp .loop_euclidian
      .change:
        cmp bx, 1
        je .one_first
        cmp cx, 1
        je .one_second
        .loop_euclidian_change:
          push cx
          push bx
          mov ax, cx ;dividento: ax | dividor: cx | quociente: ax | resto: dx
          mov dx, 0
          div bx
          pop cx
          mov bx, dx
          cmp bx, 0
          je .finish_rest_one
          cmp bx, 1
          je .finish_rest_zero
          jmp .loop_euclidian_change
      .finish_rest_zero:
        mov di, result
        mov ax, bx
        call tostring
        mov si, result
        call prints
        ret
      .finish_rest_one:
        mov di, result
        mov ax, cx
        call tostring
        mov si, result
        call prints
        ret
      .one_first:
        mov di, result
        mov ax, 1
        call tostring
        mov si, result
        call prints
        ret
      .one_second:
        mov di, result
        mov ax, 1
        call tostring
        mov si, result
        call prints
        ret

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    call intela
    mov di, string1
    call gets
    mov si, string1
    call stoi
    push ax ; função stoi ta usando o dx, por isso não entra no caso de igual
    mov di, string2
    call gets
    mov si, string2
    call stoi
    push ax
    call gdc
    call end

end:
  jmp $
times 510 - ($-$$) db 0
dw 0xaa55
