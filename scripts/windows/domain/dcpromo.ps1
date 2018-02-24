$SafeModeAdministratorPassword = ConvertTo-SecureString "P@ssW0rD1!" -AsPlainText -Force

#
# Windows PowerShell script for AD DS Deployment
#
Import-Module ADDSDeployment

#check if domain is already setup before trying to create forest
$dc = Get-ADDomainController

if ($dc -eq $null) {
    
    Install-ADDSForest `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Win2012" `
    -DomainName "mytest.local" `
    -DomainNetbiosName "MYTEST" `
    -ForestMode "Win2012" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true `
    -SafeModeAdministratorPassword $SafeModeAdministratorPassword

    Start-Sleep 120

    Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru
    Add-DnsServerForwarder -IPAddress 4.2.2.1 -PassThru

}