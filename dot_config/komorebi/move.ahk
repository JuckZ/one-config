; Ctrl - ^
; Alt - !
; Shift - +
; Win - #

!LButton::
{
    CoordMode("Mouse", "Screen")
    MouseGetPos(&StartX, &StartY, &WindowID)
    WinGetPos(&WinX, &WinY, &WinWidth, &WinHeight, "ahk_id " WindowID)
    SetMouseDelay(-1)  ; Make the mouse delay instant

    while GetKeyState("Alt", "P") && GetKeyState("LButton", "P")
    {
        MouseGetPos(&CurrentX, &CurrentY)
        deltaX := (CurrentX - StartX)
        deltaY := (CurrentY - StartY)
        NewX := Max(0, (WinX + deltaX))
        NewY := Max(0, (WinY + deltaY))
        Sleep(50)
        WinMove(NewX, NewY, WinWidth, WinHeight, "ahk_id " WindowID)
    }

    return
}
