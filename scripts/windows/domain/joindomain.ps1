Set-DNSClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ("192.168.1.150")

$domain = "mytest"
$password = "vagrant" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\vagrant" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential

start-sleep 120



