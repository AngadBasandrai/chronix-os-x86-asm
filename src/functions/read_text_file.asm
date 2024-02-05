txtFileFound:
    call clearTextScreen
    xor cx, cx

fileLoop:
    mov ah, 0x0e
    mov al, [ES:BX]
    int 0x10
    inc bx
    inc cx
    cmp cx, 512
    je endReadFile
    jmp fileLoop

endReadFile:
    call printNewLine
    mov ah, 0x00
    int 0x16
    mov ax, 0x2000
    mov es, ax
    xor bx, bx

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x2000:0x0000