;;; 
;;; 0-9: name
;;; 10-12: extension
;;; 13-14: sector
;;; 15-16: no. of sectors

db \
'bootSect  ','bin',0x0,0x1,0x0,0x1,\
'kernel    ','bin',0x0,0x2,0x0,0x4,\
'fileTable ','txt',0x0,0x6,0x0,0x1,\
'editor    ','bin',0x0,0x7,0x0,0x4,'\'

times 512-($-$$) db 0