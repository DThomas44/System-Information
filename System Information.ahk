/*
    System Information
    Author: Daniel Thomas
    Language: AutoHotkey (v1.1+)

    This script presents some basic user information in a window in the lower
    right corner of the user's screen. The window is 1 layer above the desktop
    so icons can get placed behind the window, but all other applications
    should appear above the window.
*/
;<=====  System Settings  =====================================================>
#SingleInstance Force
#NoEnv
SetBatchLines, -1
SetFormat, float, 0.2

;<=====  Timers  ==============================================================>
SetTimer, UpdateGUI, 1000 ; Update every second

;<=====  Tray Menu  ===========================================================>
Menu, Tray, NoStandard
Menu, Tray, Add, Copy Computer Information, CopyInfo

;<=====  Main  ================================================================>
; Window size and positioning
Width := 210
Height := 80
SysGet, WorkArea, MonitorWorkArea
Xpos := WorkAreaRight - Width
Ypos := WorkAreaBottom - Height

; Window style
Gui, +LastFound +ToolWindow -DPIScale -Caption
Gui, Color, 808080
Gui, Margin, 0, 0
Gui, Font, s8 cD0D0D0 Bold
WinSet, Region, 0-0 w%Width% h%Height% r6-6

; Actual content
StringUpper, UserName, A_UserName
Gui, Add, Text, x7 y+5 w196 r1 +0x4000 +Center, %UserName%
Gui, Add, Text, x7 y+5 w196 r1 +0x4000 +Center, %A_ComputerName%
Gui, Add, Text, x7 y+5 w196 r1 +0x4000 +Center vIPAddress, %A_IPAddress1%
Gui, Add, Text, x7 y+5 w196 r1 +0x4000 +Center vUpTime,
Gui, Add, Text, x7 y+5 w196 h2 ; This line just forces a bit of padding

; Update content and show window
GoSub, UpdateGUI
Gui, Show, x%Xpos% y%Ypos% w%Width% NoActivate
hwnd2 := WinExist()
WinSet, Bottom
return

;<=====  Hotkeys  =============================================================>
; Uncomment this section while testing so you can close the app
;Esc::
;    ExitApp

;<=====  Subs  ================================================================>
CopyInfo:
    ; Get username
    strOut := "Username: " . UserName . "`n"

    ; Get Logon Server
    EnvGet, LogServ, LogonServer
    strOut .= "Logon Server: " . LogServ . "`n"

    ; Get computer name
    strOut .= "Computer: " . A_ComputerName . "`n"

    ; Get up to 4 IP addresses incase system has multiple NICs
    if (A_IPAddress1 != "0.0.0.0")
        strOut .= "IP Address 1: " . A_IPAddress1 . "`n"
    if (A_IPAddress2 != "0.0.0.0")
        strOut .= "IP Address 2: " . A_IPAddress2 . "`n"
    if (A_IPAddress3 != "0.0.0.0")
        strOut .= "IP Address 3: " . A_IPAddress3 . "`n"
    if (A_IPAddress4 != "0.0.0.0")
        strOut .= "IP Address 4: " . A_IPAddress4 . "`n"
    
    ; Get OS info (version number + bitness)
    strOut .= "Operating System: " . A_OSVersion . "`n"
    strOut .= "64 Bit: " . (A_Is64bitOS ? "Yes":"No") . "`n"

    ; Get time since last restart
    strOut .= "Last restart " . UpTime . " hours ago`n`n"
    
    ; Send to clipboard and notify user
    clipboard := strOut
    ToolTip, Copied system information to clipboard.
    Sleep, 2000
    ToolTip
    return

UpdateGUI:
    ; Make sure the GUI is in the corner
    SysGet, WorkArea, MonitorWorkArea
    Xpos := WorkAreaRight - Width
    Ypos := WorkAreaBottom - Height
    WinMove, ahk_id %hwnd2%,, %Xpos%, %Ypos%

    ; Update system information
    UpTime := secToTime((A_TickCount / 1000))
    GuiControl,, UpTime, % "Last restart " . UpTime . " ago"
    if ((A_IPAddress1 != "0.0.0.0") && (!InStr(A_IPAddress1, "169.254.")) 
        && (A_IPAddress1 != "127.0.0.1")){
        GuiControl,, IPAddress, % A_IPAddress1
    }
    else if ((A_IPAddress2 != "0.0.0.0") && (!InStr(A_IPAddress2, "169.254."))
        && (A_IPAddress1 != "127.0.0.1")){
        GuiControl,, IPAddress, % A_IPAddress2
    }
    else if ((A_IPAddress3 != "0.0.0.0") && (!InStr(A_IPAddress3, "169.254."))
        && (A_IPAddress1 != "127.0.0.1")){
        GuiControl,, IPAddress, % A_IPAddress3
    }
    else if ((A_IPAddress4 != "0.0.0.0") && (!InStr(A_IPAddress4, "169.254."))
        && (A_IPAddress1 != "127.0.0.1")){
        GuiControl,, IPAddress, % A_IPAddress4
    }
    else {
        GuiControl,, IPAddress, % "No Connection"
    }
    return

;<=====  Functions  ===========================================================>
secToTime(sec){
    strOut := ""
    ; Days
    if (sec >= 86400){
        d := floor(sec/86400)
        sec -= d*86400
        if (strLen(d) < 2)
            d := "0" . d
        strOut := d . "d "
    }
    else
        strOut := "00d "
    ; Hours
    if (sec >= 3600){
        h := floor(sec/3600)
        sec -= h*3600
        if (strLen(h) < 2)
            h := "0" . h
        strOut .= h . "h "
    }
    else
        strOut .= "00h "
    ; Minutes
    if (sec >= 60){
        m := floor(sec/60)
        sec -= m*60
        if (strLen(m) < 2)
            m := "0" . m
        strOut .= m . "m "
    }
    else
        strOut .= "00m "
    ; Seconds
    sec := floor(sec)
    if (strLen(sec) < 2)
        sec := "0" . sec
    strOut .= sec . "s"

    return strOut
}
