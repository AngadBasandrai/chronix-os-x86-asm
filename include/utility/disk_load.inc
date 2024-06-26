loadDisk:

loadKernel:

    ;; read sectors into memory mode
    mov ah, 0x02

    ;; no. of sectors to read
    mov al, 0x04

    ;; cylinder no.
    mov ch, 0x00

    ;; sector no. (starts from 1 not 0)
    mov cl, 0x02

    ;; head no.
    mov dh, 0x00

    ;; drive no.
    mov dl, 0x80 ;; 0x80 is the first hard drive

    ;; es:bx forms buffer address pointer
    mov bx, 0x2000
    mov es, bx ; es = 0x2000
    mov bx, 0x0000 

    ;; reads sectors
    int 0x13 

loadFileTable:
    ;; read sectors into memory mode
    mov ah, 0x02

    ;; no. of sectors to read
    mov al, 0x01

    ;; cylinder no.
    mov ch, 0x00

    ;; sector no. (starts from 1 not 2)
    mov cl, 0x06

    ;; head no.
    mov dh, 0x00

    ;; drive no.
    mov dl, 0x80 ;; 0x80 is the first hard drive

    ;; es:bx forms buffer address pointer
    mov bx, 0x1000
    mov es, bx ; es = 0x1000
    mov bx, 0x0000 

    ;; reads sectors
    int 0x13   

    ;; reset segment registers
    mov ax, 0x2000
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov sp, 0xFFFF ; stack pointer
    mov ax, 0x9000
    mov ss, ax 

    mov ah, 0x00
    mov al, 0x03 ;;; set 80*25 txt mode 16 colors
    int 0x10

    mov ah, 0x0B ;;; set color pallete
    mov bh, 0x00
    mov bl, 0x01 ;;; bg color to set 
    int 0x10

    ;; jump to newly loaded address
    jmp 0x2000:0x0000
