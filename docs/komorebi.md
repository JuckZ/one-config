```powershell
#Install
scoop bucket add extras
scoop install komorebi
scoop install komokana
cargo install kanata
scoop install extras/autohotkey

#Config
## Gather example configurations for a new-user quickstart
komorebic.exe quick-start

#Generate a library of AutoHotKey helper functions
komorebic.exe ahk-library

#Run
komorebic.exe enable-autostart --ahk
komorebic.exe disable-autostart
```