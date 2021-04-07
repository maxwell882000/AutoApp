Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & "C:\inetpub\wwwroot\AutoApp\some.bat" & Chr(34), 0
Set WshShell = Nothing