:: https://www.microsoft.com/en-us/download/details.aspx?id=55269

choco install wget -y
if not exist c:\vagrant\download mkdir c:\vagrant\download
pushd c:\vagrant\download

:: azure backup installer
if not exist MicrosoftAzureBackupServerInstaller.exe C:\ProgramData\chocolatey\lib\wget\tools\wget.exe --no-check-certificate https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller.exe
if not exist MicrosoftAzureBackupServerInstaller-1.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe --no-check-certificate https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-1.bin
if not exist MicrosoftAzureBackupServerInstaller-2.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe --no-check-certificate https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-2.bin
if not exist MicrosoftAzureBackupServerInstaller-3.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe --no-check-certificate https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-3.bin
if not exist MicrosoftAzureBackupServerInstaller-4.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe --no-check-certificate https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-4.bin
if not exist MicrosoftAzureBackupServerInstaller-5.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe --no-check-certificate https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-5.bin
if not exist MicrosoftAzureBackupServerInstaller-6.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe --no-check-certificate https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-6.bin
if not exist MicrosoftAzureBackupServerInstaller-7.bin C:\ProgramData\chocolatey\lib\wget\tools\wget.exe --no-check-certificate https://download.microsoft.com/download/C/9/3/C93CABA5-2776-4417-8DB2-20B85E6EBA3B/MicrosoftAzureBackupServerInstaller-7.bin


:: prereqs for azure backup installer
:: .net 3.5 SP1
if not exist dotnetfx35.exe C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe
:: .net 4.6.2
if not exist NDP462-KB3151800-x86-x64-AllOS-ENU.exe C:\ProgramData\chocolatey\lib\wget\tools\wget.exe https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe

powershell -command install-windowsfeature NET-Framework-Features -IncludeAllSubFeature
powershell -command install-windowsfeature Hyper-V-PowerShell
powershell -command Enable-WindowsOptionalFeature –Online -FeatureName Microsoft-Hyper-V –All -NoRestart
powershell -command Install-WindowsFeature RSAT-Hyper-V-Tools -IncludeAllSubFeature

:: site recovery config server installer
C:\ProgramData\chocolatey\lib\wget\tools\wget.exe http://aka.ms/unifiedinstaller_wus
