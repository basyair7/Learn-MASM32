name "helloworld2.asm" ; file name "hello world :p"
.386
.model flat,stdcall
option casemap:none

; include library kernel 
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

; deklarasikan variabel
.data
    HELLOWORLDBABY db "Halo dunia!", 0
    NEWLINE db 13, 10, 0

.code

; start program
start:
    invoke StdOut, addr HELLOWORLDBABY
    invoke StdOut, addr NEWLINE
    invoke ExitProcess, 0

end start ; end program