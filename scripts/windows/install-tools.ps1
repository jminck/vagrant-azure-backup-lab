choco feature enable -n allowGlobalConfirmation
choco install googlechrome -y
choco install notepadplusplus -y
choco install sysinternals -y
choco install winrar -y
choco install wget -y

#download cmtrace (SCCM 2012 R2 tools)
wget.exe https://download.microsoft.com/download/5/0/8/508918E1-3627-4383-B7D8-AA07B3490D21/ConfigMgrTools.msi
msiexec /a ConfigMgrTools.msi /qb TARGETDIR=c:\temp\cmtools
if (!(test-path c:\tools)) {mkdir c:\tools}
copy c:\temp\cmtools\clienttools\cmtrace.exe c:\tools
rmdir /s /q c:\temp\cmtools

#download Notepad++ plugin manager
wget.exe https://github.com/bruderstein/nppPluginManager/releases/download/v1.4.11/PluginManager_v1.4.11_x64.zip
Add-Type -assembly "system.io.compression.filesystem"
$BackUpPath = "PluginManager_v1.4.11_x64.zip"
$destination = "C:\Program Files\Notepad++"
[io.compression.zipfile]::ExtractToDirectory($destination + "\" + $BackUpPath, $destination)

wget.exe https://telerik-fiddler.s3.amazonaws.com/fiddler/FiddlerSetup.exe

# Create desktop short for Sysinternals tools
$TargetFile = "C:\ProgramData\chocolatey\lib\sysinternals\tools"
$ShortcutFile = "$env:Public\Desktop\Sysinternals.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()

# install AzCopy
wget http://aka.ms/downloadazcopy -O azcopy.msi
msiexec /i azcopy.msi /qb