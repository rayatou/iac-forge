$ErrorActionPreference = "Stop"

# Switch network connection to private mode
# Required for WinRM firewall rules
$profile = Get-NetConnectionProfile
Set-NetConnectionProfile -Name $profile.Name -NetworkCategory Private

# Enable WinRM service
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Reset auto logon count
# https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0

# Opens Firewall
$FirewallParam = @{
    DisplayName = 'Windows Remote Management (HTTP-In)'
    Direction = 'Inbound'
    LocalPort = 5985
    Protocol = 'TCP'
    Action = 'Allow'
    Program = 'System'
}
New-NetFirewallRule @FirewallParam

# gci cert:\LocalMachine\my -Recurse | Remove-Item -Force -Verbose