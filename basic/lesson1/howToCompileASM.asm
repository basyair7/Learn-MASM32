; 1. run on command prompt
; 2. select on directory masm32 compile
; 3. create new folder in directory /masm32/newfolder/
; 4. paste code .asm in newfolder
; 5. run on cmd : 
; > ml /c /Zd /coff "namefile.asm"
; > link /SUBSYSTEM:CONSOLE "namefile.obj" or > link /SUBSYSTEM:WINDOWS "namefile.obj"
; > namefile