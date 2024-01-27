name "colortext.asm"
.386
.model flat, stdcall
option casemap:none

WinMain proto :DWORD, :DWORD, :DWORD, :DWORD

include \masm32\include\windows.inc
include \masm32\include\user32.inc 
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib

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
    invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    invoke ExitProcess, eax

    WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
        local wc:WNDCLASSEX
        local msg:MSG
        local hwnd:HWND
        mov wc.cbSize, sizeof WNDCLASSEX
        mov wc.style, CS_HREDRAW or CS_VREDRAW
        mov wc.lpfnWndProc, OFFSET WndProc
        mov wc.cbClsExtra, NULL
        mov wc.cbWndExtra, NULL
        push hInst
        pop wc.hInstance
        mov wc.hbrBackground, COLOR_WINDOW+1
        mov wc.lpszMenuName, NULL
        mov wc.lpszClassName, OFFSET ClassName
        invoke LoadIcon, NULL, IDI_APPLICATION
        mov wc.hIcon, eax
        mov wc.hIconSm, eax
        invoke LoadCursor, NULL, IDC_ARROW
        mov wc.hCursor, eax
        invoke RegisterClassEx, addr wc
        invoke CreateWindowEx, NULL, addr ClassName, addr AppName,\
            WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,\
            CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL,\
            hInst, NULL
        mov hwnd, eax
        invoke ShowWindow, hwnd, SW_SHOWNORMAL
        invoke UpdateWindow, hwnd
        .WHILE TRUE
            invoke GetMessage, addr msg, NULL, 0, 0
            .BREAK .IF(!eax)
            invoke TranslateMessage, addr msg
            invoke DispatchMessage, addr msg
        .ENDW
        mov eax, msg.wParam
        ret
    WinMain endp

    WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
        local hdc:HDC
        local ps:PAINTSTRUCT
        local hfont:HFONT 

        .if uMsg==WM_DESTROY
            invoke PostQuitMessage, NULL
        .elseif uMsg==WM_PAINT
            invoke BeginPaint, hWnd, addr ps
            mov hdc, eax
            invoke CreateFont, 24, 16, 0, 0, 400, 0, 0, 0, OEM_CHARSET,\
                OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,\
                DEFAULT_QUALITY, DEFAULT_PITCH or FF_SCRIPT,\
                addr FontName
            invoke SelectObject, hdc, eax
            mov hfont, eax 
            RGB 200, 200, 50
            invoke SetBkColor, hdc, eax 
            invoke TextOut, hdc, 0, 0, addr TestString, sizeof TestString
            invoke SelectObject, hdc, hfont
            invoke EndPaint, hWnd, addr ps

        .else
            invoke DefWindowProc, hWnd, uMsg, wParam, lParam
            ret
        .endif
        xor eax, eax
        ret
    WndProc endp

end start