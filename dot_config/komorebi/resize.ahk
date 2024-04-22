; !+-::ResizeDelta(10)

; Ctrl - ^
; Alt - !
; Shift - +
; Win - #

!RButton::
{
    CoordMode("Mouse", "Screen")
    MouseGetPos(&StartX, &StartY, &WindowID)
    WinGetPos(&WinX, &WinY, &WinWidth, &WinHeight, "ahk_id " WindowID)
    SetMouseDelay(-1)  ; Make the mouse delay instant
    ; Determine where the cursor is relative to the window at the time of pressing.
    HorizontalPos := StartX - WinX
    VerticalPos := StartY - WinY
    RightDist := WinWidth - HorizontalPos
    BottomDist := WinHeight - VerticalPos

    ; Decide which edges to resize based on cursor position at the moment of pressing
    ResizeRight := HorizontalPos >= RightDist
    ResizeBottom := VerticalPos >= BottomDist

    setted := false

    while GetKeyState("Alt", "P") && GetKeyState("RButton", "P")
    {
        MouseGetPos(&CurrentX, &CurrentY)
        deltaX := (CurrentX - StartX)
        deltaY := (CurrentY - StartY)

        if(setted = false) {
            NewX := WinX
            NewY := WinY
            setted := true
        }

        ; Adjust width and height based on initial side determination
        if (ResizeRight) {
            NewWidth := Max(10, WinWidth + deltaX)
        } else {
            NewWidth := Max(10, WinWidth - deltaX)
            NewX := Max(0, (WinX + deltaX))
        }

        if (ResizeBottom) {
            NewHeight := Max(10, WinHeight + deltaY)
        } else {
            NewHeight := Max(10, WinHeight - deltaY)
            NewY := Max(0, (WinY + deltaY))
        }
        Sleep(50)
        ; Use WinMove to resize or move the window
        WinMove(NewX, NewY, NewWidth, NewHeight, "ahk_id " WindowID)
    }

    return
}
