name "colortext.asm"
.386
.model flat, stdcall
option casemap:none

WinMain proto :DWORD, :DWORD, :DWORD, :DWORD

include \masm32\include\windows.inc
include \masm32\include\user32.inc 
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

RGB macro red, green, blue
    xor eax, eax
    mov ah, blue
    shl eax, 8
    mov ah, green
    mov al, red
endm

.data
    ClassName db "SimpleWinClass", 0
    AppName db "Our First Window", 0
    TestString db "Hello Ahul, Win32 assembly is great and easy!", 0
    FontName db "script", 0
.data?
    hInstance HINSTANCE ?
    CommandLine LPSTR ?
.code
start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax
    invoke GetCommandLine
    mov CommandLine, eax 
    invoke 