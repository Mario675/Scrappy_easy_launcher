#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
/*
    Author: Mario675 Scrappy Ez Connect

    I need to add the feture to connect to different networks. Right now it only connects to my computer because of the built
    in mouse movement. This program should be able to identify the ip, without build in customization.

    scrcpy Seems to have been disabled in the shortcut version, so how about running two different versions from the shortcut?
    added feture keep awake, for convince, so that device settings does not have to go to sleep. 
    For future reference dev notes
    DO NOT
    winwait "ahk_exe notepad.exe"
    DO
    winwait ahk_exe notepad.exe


    Now added the capability to connect to ANY network of ip!
    Removed variable confusion
    Added a function for easy ending options.

    tbd ADD IN FAILSAFE IN CASE DEVICE NOT CONNECTED. bc it will go through and waste time. 
    tbd Add in a variable for the user to easaly change their devices screen resulution.
    tdb add in a config file, or use a gui program to configure options.
    tdb Add in Ctrl+x To terminate script. 
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
    send cd C:\adb `n
    return
}
Shortcuts_Setting := 0 ;0 OR 1.;This Controls the shortcut setting, and the switch funtion below, handles the cases. Though, pointless with the mod. 
Switch_Number := 0   ;dev notes:Needed to add the new := declaration in order to work.
Switch_Shortcut_Cases(Switch_Number) ;This ends the command, with the final scrappy Command. This includes an option to have shortcuts available. 
{
    switch Switch_Number
    {
        case 1: ;Wired
        send `n 
        ;msgbox Case 1`n%wire_less%`nWired ;Debug
        return

        case 2: 
        ;Wireless
        send ./scrcpy --bit-rate 2M --max-size 800 --stay-awake`n 
        ;msgbox Case 2`n%wire_less%`nWireless ;Debug
        return

        case 1.2:  ;Wired_Shortcut-Included
        send scrcpy -m 1024 --shortcut-mod=lctrl{+}lalt,lcmd,rcmd `n
        ;msgbox Case 1.2 `n%wire_less%`nWired_Shortcut-Included ;Debug
        return

        case 2.2:  ;Wireless_Shortcut-Included
        send ./scrcpy --bit-rate 2M --max-size 800 --shortcut-mod=lctrl{+}lalt,lcmd,rcmd `n ;+ is interperted as shift rather than typing it out.
        ;msgbox Case 2.2 `n%wire_less%`nWireless_Shortcut-Included ;Debug
        return

    }
;msgbox, I should of done a case. ;Debug
return
}

wire_less = 9 ;Somthing other than 0 or 1
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
    return
}

Ifmsgbox, no
{
    Startup_Powershell_n_prepare_adb()
    End_Settings(0, Shortcuts_Setting)  
    return
}

IfMsgBox, Cancel
return 

^x::
exitapp
    