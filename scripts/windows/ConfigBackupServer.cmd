:: https://www.microsoft.com/en-us/download/details.aspx?id=55269

choco install wget -y
if not exist c:\vagrant\download mkdir c:\vagrant\download
pushd c:\vagrant\download

if not exist MicrosoftAzureBackupServerInstaller.exe C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller.exe
if not exist MicrosoftAzureBackupServerInstaller-1.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-1.bin
if not exist MicrosoftAzureBackupServerInstaller-2.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-2.bin
if not exist MicrosoftAzureBackupServerInstaller-3.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-3.bin
if not exist MicrosoftAzureBackupServerInstaller-4.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-4.bin
if not exist MicrosoftAzureBackupServerInstaller-5.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-5.bin
if not exist MicrosoftAzureBackupServerInstaller-6.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-6.bin
if not exist MicrosoftAzureBackupServerInstaller-7.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-7.bin

C:\ProgramData\chocolatey\lib\wget\tools\wget.exe http://aka.ms/unifiedinstaller_wus

powershell -command install-windowsfeature NET-Framework-Features -IncludeAllSubFeature
powershell -command install-windowsfeature Hyper-V-PowerShell
powershell -command Enable-WindowsOptionalFeature –Online -FeatureName Microsoft-Hyper-V –All -NoRestart
powershell -command Install-WindowsFeature RSAT-Hyper-V-Tools -IncludeAllSubFeature