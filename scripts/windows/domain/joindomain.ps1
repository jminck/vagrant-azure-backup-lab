Set-DNSClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("192.168.1.150")

# disable IPV6 
$ipV6 = get-netadapterbinding | where-object {$_.componentID -eq "ms_tcpip6"}
set-netadapterbinding -Name $ipV6.Name -ComponentID ms_tcpip6 -Enabled $false

$domain = "mytest"
$password = "vagrant" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\vagrant" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential

start-sleep 120



