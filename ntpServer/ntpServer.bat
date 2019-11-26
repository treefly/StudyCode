rem set command path

set path=%SystemRoot%;%SystemRoot%\system32

rem modify register items

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DataTime\Servers" /v "0" /t REG_SZ /d "192.168.3.41" /f

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient" /v "Enabled" /t REG_DWORD /d "0x00000001" /f

rem after client setting,resync time

w32tm /config /manualpeerlist:192.168.3.41,0x8 /syncfromflags:MANUAL

net stop w32time

net start w32time

w32tm /resync

rem the windows time service starts automatically with the system

sc config w32time start= auto
