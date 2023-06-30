$SHELL_DIR=$env:SHELL_DIR
. "$SHELL_DIR\scLib.ps1"

$myVar = if ($env:MY_ENV_VAR) { $env:MY_ENV_VAR } else { "default value" };

If($WSUS_IS_INTERNAL) 
{ 
  Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name WUServer -Value $WSUS_INTERNAL_WUServer
  Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name WUStatusServer -Value $WSUS_INTERNAL_WUServer
  Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name UseWUServer -Value 1 -Type DWord
  gpupdate /force 
}

Install-PackageProvider -Name NuGet -Force
Install-Module -Name PSWindowsUpdate -Force

Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

 

