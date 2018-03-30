:: this is here because the Server 2012 (not R2) image we're using  doesn't have Chocolatey preinstalled
:: we need it because MABS requires Hyper-V role, and it won't install on R2
:: thats why the base image for this machine is different than the others

@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"