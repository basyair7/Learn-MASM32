name "paintwithtext.asm"
.386
.model flat,stdcall
option casemap:none

WinMain proto :DWORD, :DWORD, :DWORD, :DWORD

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.DATA
ClassName db "SimpleWinClass", 0
AppName db "Our First Window", 0
OurText db "Win32 assembly is great and easy!", 0

.DATA?
hInstance HINSTANCE ?
CommandLine LPSTR ?

.CODE 
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
        mov wc.cbSize, SIZEOF WNDCLASSEX
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
            CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT, NULL, NULL,\
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
        local rect:RECT 
        .IF uMsg==WM_DESTROY
            invoke PostQuitMessage, NULL
        .ELSEIF uMsg==WM_PAINT
            invoke BeginPaint, hWnd, addr ps
            mov hdc, eax
            invoke GetClientRect, hWnd, addr rect
            invoke DrawText, hdc, addr OurText, -1, addr rect,\
                DT_SINGLELINE or DT_CENTER or DT_VCENTER 
            invoke EndPaint, hWnd, addr ps
        .ELSE
            invoke DefWindowProc,hWnd,uMsg,wParam,lParam
            ret
        .ENDIF
        xor eax, eax
        ret
    WndProc endp
end start
