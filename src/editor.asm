startEditor:
    call clearTextScreen

    ;; TODO: allow to open existing file

    mov ax, 0x0B800 ;; start of video memory for text mode
    mov es, ax
    xor di, di

    mov si, newFileMsg
    mov cx, 44
    cld

    rep movsw

    ;; TODO: remove interrupt
    mov ah, 0x02 ; int 0x10, ah 0x02 = move hardware cursor
    xor bh, bh ;page no.
    xor dh, dh
    mov dl, 44 ;spaces to move cursor ahead by
    int 0x10

    mov ah, 0x00
    int 0x16
    cmp al, 'O'
    je startEditor
    cmp al, 'o'
    je startEditor
    cmp al, 'N'
    je editor
    cmp al, 'n'
    je editor
    jmp startEditor

editor:
    call clearTextScreen
    mov word di, 0x0F00 ;; es:di = start of vid mem: 80(columns)*24(rows)*2(2 chars per byte)
    mov si, bottomMsg
    mov cx, 54  ; no. of chars in bottomMsg
    cld

    rep movsw ; mov [di], [si] until cx = 0 and increment both si and di and decrement cx

    mov ax, 0x8000
    mov es, ax

    xor cx, cx

    mov di, hexCode

editorLoop:
    xor ax, ax
    int 0x16
    cmp al, '\'
    je executeCode
    cmp al, '$'
    je endEditor
    cmp al, '0'
    jl editorLoop
    cmp al, '9'
    jg checkLetter
    jmp _endLetter
    checkLetter:
        cmp al, 'A'
        jl editorLoop
        cmp al, 'F'
        jg checkLowerCase
        jmp _endLetter
    checkLowerCase:
        cmp al, 'a'
        jl editorLoop
        cmp al, 'f'
        jg editorLoop
        sub al, 0x20
    _endLetter:
    mov ah, 0x0e
    int 0x10
    call asciiToHex
    inc cx
    cmp cx, 2
    je addToCode
    mov [hexByte], al
returnToLoop:  
    jmp editorLoop

asciiToHex:
    cmp al, 0x39
    jle hexNum
    sub al, 0x37
_asciiToHex:
    ret
hexNum:
    sub al, 0x30
    jmp _asciiToHex

addToCode:
    rol byte [hexByte], 4 ;; shifts hexByte 4 bits left i.e one digit left
    or byte [hexByte], al ;; put al into 2nd digit
    mov al, [hexByte]
    stosb   ; equivalent to mov [di],al inc di
    xor cx, cx
    mov al, ' '
    int 0x10
    jmp returnToLoop

executeCode:
    call saveFile

    call printNewLine
    mov si, savedMsg
    call printString
    mov ah, 0x00
    int 0x16

    jmp startEditor

endEditor:
    mov ax, 0x2000
    mov es, ax
    xor bx, bx

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    jmp 0x2000:0x0000 

addReturnCommand:
    mov al, 0xB8
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0x00
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0x00
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0xCD
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0x16
    mov [hexByte], al
    mov al, [hexByte]
    mov [di], al
    inc di
    mov al, 0xC3
    mov [hexByte], al
    mov [di], al
    inc di
    ret

hexByte: db 0x00

newFileMsg: db 'O', 0x1F, 'p', 0x1F, 'e', 0x1F, 'n', 0x1F, ' ', 0x1F, 'E', 0x1F, 'x', 0x1F, 'i', 0x1F, 's', 0x1F,\
't', 0x1F, 'i', 0x1F, 'n', 0x1F, 'g', 0x1F, ' ', 0x1F, 'F', 0x1F, 'i', 0x1F, 'l', 0x1F, 'e', 0x1F, '(', 0x1F,\
'O', 0x1F, ')', 0x1F, ' ', 0x1F, 'O', 0x1F, 'r', 0x1F, ' ', 0x1F, 'C', 0x1F, 'r', 0x1F, 'e', 0x1F, 'a', 0x1F,\
't', 0x1F, 'e', 0x1F, ' ', 0x1F, 'N', 0x1F, 'e', 0x1F, 'w', 0x1F, ' ', 0x1F, 'F', 0x1F, 'i', 0x1F, 'l', 0x1F,\
'e', 0x1F, '(', 0x1F, 'N', 0x1F, ')', 0x1F, '?', 0x1F, 0

bottomMsg: db 'E', 0x1F, 'd', 0x1F,'i', 0x1F,'t', 0x1F,'o', 0x1F,'r', 0x1F,':', 0x1F,' ',\
0x1F,'H', 0x1F,'e', 0x1F,'x', 0x1F,' ', 0x1F,'m', 0x1F,'o', 0x1F,'d', 0x1F,'e', 0x1F,\
' ', 0x1F,' ', 0x1F,' ', 0x1F,' ', 0x1F,' ', 0x1F, ' ', 0x1F,' ', 0x1F,\
' ', 0x1F,' ', 0x1F,' ', 0x1F,' ', 0x1F,' ', 0x1F,' ', 0x1F, '\', 0x1F,' ', 0x1F,'=', 0x1F,' ', 0x1F,\
'S', 0x1F,'a', 0x1F,'v', 0x1F,'e', 0x1F,' ', 0x1F,' ', 0x1F,'$', 0x1F,' ', 0x1F, '=', 0x1F,' ',\
0x1F,'E', 0x1F,'x', 0x1F,'i', 0x1F,'t', 0x1F,' ',0x1F,'E', 0x1F,'d', 0x1F,'i', 0x1F,'t', 0x1F,'o', 0x1F,'r', 0x1F,0

savedMsg: db 'File Saved!', 0

hexCode: times 511 db 0

    %include "include/screen/clear_text_screen.inc"
    %include "include/functions/print_string.inc"
    %include "include/functions/print_hex.inc"
    %include "include/functions/save_file.inc"
    %include "include/utility/macros.inc"
    %include "include/utility/vars.inc"

times 2048-($-$$) db 0