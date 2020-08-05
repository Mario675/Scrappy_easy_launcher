#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
/*
    Author: Mario675 Scrappy Ez Connect

    For future reference dev notes
    DO NOT
    winwait "ahk_exe notepad.exe"
    DO
    winwait ahk_exe notepad.exe


    Transferred Issues and bug patches to github. No longer have to update this section. 
*/




Switch_Number := 0
User_errors(Switch_Number)
{
    switch Switch_Number
    {
        case 1:
        msgbox, INCORRECT VALUE for Shortcuts_Setting!!!`nMust be 0 or 1!!!! `n"%Shortcuts_Setting%"
        return

    }
}





Startup_Powershell_n_prepare_adb()
{
    ;Open Powershell
    run Powershell.exe
    sleep 1000

    ;Justs in cases Before code
    send cls `n
    send adb disconnect `n
    send echo off `n

    IniRead, ADB_PATH, %A_ScriptDir%/Settings.ini, Path_ADB_s, ADB_PATH [, Default]

    send cd %ADB_PATH% `n
    return
}



IniRead, Shortcuts_Setting, %A_ScriptDir%/Settings.ini, Shortcut_Mod_s, Shortcuts_Setting
;0 OR 1.;This Controls the shortcut setting, and the switch function below, handles the cases. Though, pointless with the mod, because it works anyways. 

Switch_Number := 0   ;dev notes:Needed to add the new := declaration in order to work.

Switch_Shortcut_Cases(Switch_Number) ;This ends the command, with the final scrappy Command. This includes an option to have shortcuts available. 
{
    IniRead, screenResolution, %A_ScriptDir%/Settings.ini, Screen_Resolution_s, screenResolution
    IniRead, max_Size,  %A_ScriptDir%/Settings.ini, Screen_Resolution_s, max_Size
    ;IniRead, OutputVar, Filename, Section, Key [, Default]

    switch Switch_Number
    {
        case 1: ;Wired
        send scrcpy -m %screenResolution% --stay-awake`n 
        ;msgbox Case 1`n%wire_less%`nWired ;Debug
        return

        case 2: 
        ;Wireless
        send ./scrcpy --bit-rate 2M --max-size %max_Size% --stay-awake`n 
        ;msgbox Case 2`n%wire_less%`nWireless ;Debug
        return

        case 1.2:  ;Wired_Shortcut-Included
        send scrcpy -m %screenResolution% --shortcut-mod=lctrl{+}lalt,lcmd,rcmd `n
        ;msgbox Case 1.2 `n%wire_less%`nWired_Shortcut-Included ;Debug
        return

        case 2.2:  ;Wireless_Shortcut-Included
        send ./scrcpy --bit-rate 2M --max-size %max_Size% --shortcut-mod=lctrl{+}lalt,lcmd,rcmd `n ;+ is interperted as shift rather than typing it out.
        ;msgbox Case 2.2 `n%wire_less%`nWireless_Shortcut-Included ;Debug
        return

    }
;msgbox, I should of done a case. ;Debug
return
}

wire_less = 9 ;Somthing other than 0 or 1. wired/Wireless is determined end of ifmsgbox.
End_Settings(wire_less, Shortcuts_Setting)
{
    if Shortcuts_Setting = 0
    {
        Switch_Shortcut_Cases(1+wire_less)
        return
    }
    
    if Shortcuts_Setting = 1
    {
        Switch_Shortcut_Cases(1.2+wire_less)
        return
    }
    Else
    {
        msgbox %Shortcuts_Setting%
        User_errors(1)
        return
    }
}

msgbox, 3, Scrcpy Ez Connector 4.1,Please Connect Device`n Wireless=Yes `n Wired=No`n`n 

Ifmsgbox, yes
{
    wire_less = 1
    Startup_Powershell_n_prepare_adb()



    ;Get ip 
    ;step 1
    send adb shell ip route > C:\adb\Your_Ip_Network.txt`n
    sleep 500

    ;step 2
    send notepad.exe "Your_Ip_Network.txt" `n


    winwait, ahk_exe notepad.exe
    WinActivate, ahk_exe notepad.exe
    sleep 1000
    WinMaximize, ahk_exe notepad.exe ;Because of end fooling word wrap!
    sleep 300

    clipboard = 
    send {end}
    sleep 300
    send {bs}
    sleep 300
    send ^+{left}
    sleep 300
    send ^c
    ;STEP kill the correct notepad window

    
    winget Programs_Notepad_Proccess_PID, PID, A
    ;msgbox %Programs_Notepad_Proccess_PID% ;Debug
    


    WinActivate, ahk_exe powershell.exe
    send kill %Programs_Notepad_Proccess_PID%`n

    ;Conflition with above causes cmd to open. ctrl and shift + c = cmd
    ;open tcp
    send adb tcpip 5555 `n 
    send adb connect ^v:5555 `n





    ;Launch scrcpy
 msgbox, 0, Waiting, Once Disconnected`npress ok.`nPress Esc to close
    Ifmsgbox, Ok
    End_Settings(1, Shortcuts_Setting)
    exitapp
}

Ifmsgbox, no
{
    Startup_Powershell_n_prepare_adb()
    End_Settings(0, Shortcuts_Setting)  
    exitapp
}

IfMsgBox, Cancel
return 

^x::
exitapp
    