choco install openssh -params '"/SSHServerFeature /KeyBasedAuthenticationFeature"' -confirm
choco install vim -y
choco install git -y

choco install bginfo -y
expand-archive \vagrant\scripts\windows\bginfo.zip C:\ProgramData\chocolatey\bin 
New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
Set-ItemProperty "HKU:\.Default\Software\Microsoft\Windows\CurrentVersion\Run" -Name 'BGInfo' -Value "bginfo.exe C:\ProgramData\chocolatey\bin\bginfo.bgi /timer:0 /nolicprompt /silent"
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name 'BGInfo' -Value "bginfo.exe C:\ProgramData\chocolatey\bin\bginfo.bgi /timer:0 /nolicprompt /silent"
bginfo.exe C:\ProgramData\chocolatey\bin\bginfo.bgi /timer:0 /nolicprompt /silent


#Allow WMI for ASR agent push install
netsh advfirewall firewall set rule group="windows management instrumentation (wmi)" new enable=yes

#open RDP port
netsh advfirewall firewall delete rule name="Remote Desktop - User Mode (TCP-In)"
netsh advfirewall firewall add rule name="Remote Desktop - User Mode (TCP-In)" dir=in action=allow service="TermService" description="Inbound rule for the Remote Desktop service to allow RDP traffic. [TCP 3389]" enable=yes  localport=3389 protocol=tcp
netsh advfirewall firewall delete rule name="Remote Desktop - User Mode (UDP-In)" 
netsh advfirewall firewall add rule name="Remote Desktop - User Mode (UDP-In)" dir=in action=allow service="TermService" description="Inbound rule for the Remote Desktop service to allow RDP traffic. [UDP 3389]" enable=yes  localport=3389 protocol=udp
#disable NLA for RDP
(Get-WmiObject -class Win32_TSGeneralSetting -Namespace root\cimv2\terminalservices -ComputerName $env:ComputerName -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)

#DPM/MABS ports
netsh advfirewall firewall set rule group="COM+ Network Access" new  enable=yes
netsh advfirewall firewall set rule group="COM+ Remote Administration" new  enable=yes
netsh advfirewall firewall add rule name="DPM Agent 5718-5719/TCP" dir=in action=allow description="Inbound rule for DPM Agent [TCP 5718/5719]" enable=yes  localport=5718-5719 protocol=tcp
Netsh advfirewall firewall add rule name = "DPM agent coordinator" dir=in program="C:\Program Files\Microsoft Data Protection Manager\DPM\ProtectionAgents\AC\12.0.332.0\dpmac.exe" action=allow
# havent goteen the above sorted out so brut forcing the subnet
# allow DPM agent push from backup servers 
# needs a bunch of ports open https://technet.microsoft.com/en-us/library/hh758204(v=sc.12).aspx
netsh advfirewall firewall add rule name="Allow DPM Remote Agent Push" dir=in action=allow service=any enable=yes profile=any remoteip=192.168.1.101-192.168.1.254



#nasty - Hyper-v shared folder isn't working, not sure why but credentials used in Vagrantfile don't work for accessing c:\vagrant share to . on host
cmdkey /add:192.168.1.104 /user:vagrant /pass:vagrant