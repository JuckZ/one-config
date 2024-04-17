+RButton::
{
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

    while GetKeyState("Shift", "P") && GetKeyState("RButton", "P")
    {
        MouseGetPos(&CurrentX, &CurrentY)
        NewWidth := WinWidth
        NewHeight := WinHeight
        NewX := WinX
        NewY := WinY

        ; Adjust width and height based on initial side determination
        if (ResizeRight) {
            NewWidth := Max(100, WinWidth + (CurrentX - StartX))
        } else {
            NewWidth := Max(100, WinWidth - (CurrentX - StartX))
            NewX := CurrentX
        }

        if (ResizeBottom) {
            NewHeight := Max(100, WinHeight + (CurrentY - StartY))
        } else {
            NewHeight := Max(100, WinHeight - (CurrentY - StartY))
            NewY := CurrentY
        }

        ; Use WinMove to resize or move the window
        WinMove(NewX, NewY, NewWidth, NewHeight, "ahk_id " WindowID)
    }
    return
}
