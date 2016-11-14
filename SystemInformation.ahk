#SingleInstance Force
#NoEnv
SetBatchLines, -1
SetFormat, float, 0.2

SetTimer, UpdateGUI, 1000 ; Update every SECOND

Width := 210
Height := 96
SysGet, WorkArea, MonitorWorkArea
Xpos := WorkAreaRight - Width
Ypos := WorkAreaBottom - Height

Menu, Tray, NoStandard
Menu, Tray, Add, Copy Computer Information, CopyInfo

Gui, +LastFound +ToolWindow -DPIScale
Gui, Color, 808080
Gui, Margin, 0, 0
Gui, Font, s11 cD0D0D0 Bold
Gui, Add, Progress, x-1 y-1 w212 h15 Background404040 Disabled hwndHPROG
Control, ExStyle, -0x20000,, ahk_id %HPROG%
Gui, Font, s8
StringUpper, UserName, A_UserName
Gui, Add, Text, x7 y+5 w196 r1 +0x4000 +Center, %UserName%
Gui, Add, Text, x7 y+5 w196 r1 +0x4000 +Center, %A_ComputerName%
Gui, Add, Text, x7 y+5 w196 r1 +0x4000 +Center vIPAddress, %A_IPAddress1%
Gui, Add, Text, x7 y+5 w196 r1 +0x4000 +Center vUpTime,
Gui, Add, Text, x7 y+5 w196 h10 vP
Gui, -Caption
WinSet, Region, 0-0 w%Width% h%Height% r6-6
GoSub, UpdateGUI
Gui, Show, x%Xpos% y%Ypos% w%Width% NoActivate
hwnd2 := WinExist()
WinSet, Bottom
return

CopyInfo:
   strOut := "Computer: " . A_ComputerName . "`n"
   if (A_IPAddress1 != "0.0.0.0")
      strOut .= "IP Address 1: " . A_IPAddress1 . "`n"
   if (A_IPAddress2 != "0.0.0.0")
      strOut .= "IP Address 2: " . A_IPAddress2 . "`n"
   if (A_IPAddress3 != "0.0.0.0")
      strOut .= "IP Address 3: " . A_IPAddress3 . "`n"
   if (A_IPAddress4 != "0.0.0.0")
      strOut .= "IP Address 4: " . A_IPAddress4 . "`n"
   strOut .= "Operating System: " . A_OSVersion . "`n"
   strOut .= "64 Bit: " . (A_Is64bitOS ? "Yes":"No") . "`n"
   strOut .= "Last restart " . UpTime . " hours ago.`n`n"
   clipboard := strOut
   ToolTip, Copied system information to clipboard.
   Sleep, 2000
   ToolTip
   Return

UpdateGUI:
   ; Make sure the GUI is in the corner
   SysGet, WorkArea, MonitorWorkArea
   Xpos := WorkAreaRight - Width
   Ypos := WorkAreaBottom - Height
   WinMove, ahk_id %hwnd2%,, %Xpos%, %Ypos%
   ; Update system information
   UpTime := ((A_TickCount / 1000)/60)/60
   GuiControl,, UpTime, Last restart %UpTime% hours ago.
   GuiControl,, IPAddress, %A_IPAddress1%
   return

/*
ShellMessage(wParam, lParam){
   global hwnd1, hwndDesktop
   DllCall("SetWindowPos", "uint", hwnd, "uint", hwndDesktop, "int", 0, "int"
      , 0, "int", 0, "int", 0, "uint", 3)
}
*/
