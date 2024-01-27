; run on command prompt
; select on directory masm32 compile

ml /c /Zd /coff "namefile.asm"
link /SUBSYSTEM:CONSOLE "namefile.obj"
namefile