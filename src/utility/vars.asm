welcome: db 'Kernel Booted!', 0xA, 0xD,\
 '--------------', 0xA, 0xD, 0xA, 0xD,\
  'F) File Browser', 0xA, 0xD,\
   'R) Reboot',0xA, 0xD,\
    0xA,0xD, 0

nl: db 0xA, 0xD, 0

fileTableHeading: db '--------------------------------', 0xA, 0xD,\
 'File/Program              Sector', 0xA,0xD,\
 '--------------------------------', 0xA,0xD,\
 0xA,0xD,0

success: db 'Command ran successfully!', 0xA, 0xD, 0

failure: db 'Command not found!', 0xA, 0xD, 0

cmdString: db '', 0