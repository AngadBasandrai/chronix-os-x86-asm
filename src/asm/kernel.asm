
    mov ah, 0x00 ;;; clear screen
    mov al, 0x03
    int 0x10

    mov ah, 0x0B ;;; set background color mode
    mov bh, 0x00
    mov bl, 0x01 ;;; color to set to
    int 0x10

    mov si, welcome
    call printString

    jmp $


    ;;; Includes
    %include "src/functions/print_string.asm"
    %include "src/utility/vars.asm"

times 512-($-$$) db 0
