winrm set winrm/config/service @{CertificateThumbprint=""}
Winrm quickconfig
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/Service @{MaxConcurrentOperationsPerUser="1500"}winrm set winrm/config/winrs @{MaxConcurrentUsers="100"}
winrm set winrm/config/winrs @{MaxProcessesPerShell="100"}
winrm set winrm/config/winrs @{MaxShellsPerUser="100"}
Sc.exe config winrm type=own 
Sc.exe config winmgmt type=own
