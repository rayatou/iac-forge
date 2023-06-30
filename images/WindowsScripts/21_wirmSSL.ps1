$ErrorActionPreference = "Stop"

$MyServer = [System.Net.Dns]::GetHostByName($env:computerName).HostName
Write-Host  $MyServer 

New-SelfSignedCertificate -Subject "$MyServer" -TextExtension '2.5.29.37={text}1.3.6.1.5.5.7.3.1' -NotAfter (Get-Date).AddYears(20)
$MyServerThumb=(Get-ChildItem Cert:\LocalMachine\my).Thumbprint
Write-Host $MyServerThumb


# Enable WinRM service
winrm quickconfig -quiet
winrm set winrm/config/service '@{EnableCompatibilityHttpsListener="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{CredSSP="true"}'
 
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=""$MyServer""; CertificateThumbprint=""$MyServerThumb""}"

# Opens Firewall
$FirewallParam = @{
    DisplayName = 'Windows Remote Management (HTTPS-In)'
    Direction = 'Inbound'
    LocalPort = 5986
    Protocol = 'TCP'
    Action = 'Allow'
    Program = 'System'
}
New-NetFirewallRule @FirewallParam

# gci cert:\LocalMachine\my -Recurse | Remove-Item -Force -Verbose