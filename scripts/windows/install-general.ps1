choco install openssh -params '"/SSHServerFeature /KeyBasedAuthenticationFeature"' -confirm
choco install vim -y
choco install git -y

choco install bginfo -y
robocopy . C:\ProgramData\chocolatey\bin bginfo.bgi
New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
Set-ItemProperty "HKU:\.Default\Software\Microsoft\Windows\CurrentVersion\Run" -Name 'BGInfo' -Value "bginfo.exe C:\ProgramData\chocolatey\bin\bginfo.bgi /timer:0 /nolicprompt /silent"
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name 'BGInfo' -Value "bginfo.exe C:\ProgramData\chocolatey\bin\bginfo.bgi /timer:0 /nolicprompt /silent"
bginfo.exe C:\ProgramData\chocolatey\bin\bginfo.bgi /timer:0 /nolicprompt /silent

# allow DPM agent push from backup servers 
# needs a bunch of ports open https://technet.microsoft.com/en-us/library/hh758204(v=sc.12).aspx
netsh advfirewall firewall add rule name="Allow DPM Remote Agent Push" dir=in action=allow service=any enable=yes profile=any remoteip=192.168.1.101
netsh advfirewall firewall add rule name="Allow DPM Remote Agent Push" dir=in action=allow service=any enable=yes profile=any remoteip=192.168.1.102