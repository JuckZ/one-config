; #Requires AutoHotkey v2.0
#SingleInstance Force

; Load library
#Include komorebic.lib.ahk
#Include resize.ahk

;- KOMOREBIC
; Ctrl - ^
; Alt - !
; Shift - +
; Win - #

; Reload Configuration
!+r::Run "komorebic.exe  reload-configuration"

; Focus windows
!h::Focus("left")
!j::Focus("down")
!k::Focus("up")
!l::Focus("right")
!Left::Focus("left")
!Down::Focus("down")
!Up::Focus("up")
!Right::Focus("right")
!+[::CycleFocus("previous")
!+]::CycleFocus("next")

!Enter::{
  RunWait("alacritty.exe")
}

; Move windows
!+Left::Move("left")
!+Down::Move("down")
!+Up::Move("up")
!+Right::Move("right")
!+h::Move("left")
!+j::Move("down")
!+k::Move("up")
!+l::Move("right")
!+Enter::Promote()

; Stack windows
; TODO
; !Left::Stack("left")
; !Right::Stack("right")
; !Up::Stack("up")
; !Down::Stack("down")
!;::Unstack()
![::CycleStack("previous")
!]::CycleStack("next")

; Resize
; !=::ResizeAxis("horizontal", "increase")
; !-::ResizeAxis("horizontal", "decrease")
; !+=::ResizeAxis("vertical", "increase")
; !+-::ResizeAxis("vertical", "decrease")

; ResizeDelta 50
!=::ResizeAxis("horizontal", "increase")
!-::ResizeAxis("horizontal", "decrease")

; Manipulate windows
!t::ToggleFloat()
!+f::ToggleMonocle()

; Window manager options
; !+r::Retile()
!p::TogglePause()

; Layouts
!x::FlipLayout("horizontal")
!y::FlipLayout("vertical")
; !+l::CycleLayout("next")

; Workspaces
!1::FocusWorkspace(0)
!2::FocusWorkspace(1)
!3::FocusWorkspace(2)
!4::FocusWorkspace(3)
!5::FocusWorkspace(4)
!6::FocusWorkspace(5)
!7::FocusWorkspace(6)
!8::FocusWorkspace(7)
!9::FocusWorkspace(8)
!0::FocusWorkspace(9)

; Move windows across workspaces
!+1::MoveToWorkspace(0)
!+2::MoveToWorkspace(1)
!+3::MoveToWorkspace(2)
!+4::MoveToWorkspace(3)
!+5::MoveToWorkspace(4)
!+6::MoveToWorkspace(5)
!+7::MoveToWorkspace(6)
!+8::MoveToWorkspace(7)
!+9::MoveToWorkspace(8)
!+0::MoveToWorkspace(9)

; Caps lock as Esc
; Capslock::Esc