$SHELL_DIR=$env:SHELL_DIR
. "$SHELL_DIR\scLib.ps1"

$mProgram   = "10_CloudInit-Install"
$mModule    = "Install"

$AdminUser=$env:AdminUser
$CloudAdmin=$env:CloudAdmin
$AdminGroup=$env:AdminGroup
$Password= $WIN64_ADMIN_DEFAULT_PASS | ConvertTo-SecureString -AsPlainText -Force

$op = Get-LocalUser | Where-Object {$_.Name -eq "$CloudAdmin"}
if ( -not $op)
{
  New-LocalUser $CloudAdmin -Password $Password -FullName "$CloudAdmin" -Description "$CloudAdmin"
}

$existingMember = Get-LocalGroupMember -Name $AdminGroup | Where {$_.Name -eq  "$env:Computername\$CloudAdmin"}
if (! $existingMember)
{
  Add-LocalGroupMember -Group $AdminGroup -Member $CloudAdmin -Verbose 
}

$ProgressPreference = 'SilentlyContinue'
new-item -path "C:\Program Files\" -name "Cloudbase Solutions" -itemtype directory -Force > $null
new-item -path "$WIN64_CLOUDINIT_DIR" -name bin -itemtype directory -Force > $null
new-item -path "$WIN64_CLOUDINIT_DIR" -name log -itemtype directory -Force > $null
new-item -path "$WIN64_CLOUDINIT_DIR" -name scripts -itemtype directory -Force > $null

Invoke-WebRequest -Uri $WIN64_CLOUDINIT_MSI -OutFile "C:\Windows\Temp\CloudbaseInitSetup_x64.msi"

$Host.UI.RawUI.WindowTitle = "Installing Cloudbase-Init..."
$serialPortName = @(Get-WmiObject Win32_SerialPort)[0].DeviceId

$p = Start-Process -Wait -PassThru -FilePath msiexec -ArgumentList "/i C:\Windows\Temp\CloudbaseInitSetup_x64.msi /qn /l*v ""$WIN64_CLOUDINIT_DIR\log\cloudbase-init-install.txt""  USERNAME=""$AdminUser"" USERGROUPS=""$AdminGroup"" RUN_SERVICE_AS_LOCAL_SYSTEM=1"
if ($p.ExitCode -ne 0) {
    throw "Installing Cloudbase-Init failed. Log: $WIN64_CLOUDINIT_DIR\log\cloudbase-init-install.txt"
}

$confFile = 'cloudbase-init-unattend.conf'
$confPath = "$WIN64_CLOUDINIT_DIR\conf\"
$confContent = @"
[DEFAULT]
username=$AdminUser
groups=$AdminGroup
inject_user_password=true
config_drive_raw_hhd=true
config_drive_cdrom=true
config_drive_vfat=true
first_logon_behaviour=no
bsdtar_path=$WIN64_CLOUDINIT_DIR\bin\bsdtar.exe
mtools_path=$WIN64_CLOUDINIT_DIR\bin\
verbose=true
debug=true
logdir=$WIN64_CLOUDINIT_DIR\log\
logfile=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=$WIN64_CLOUDINIT_DIR\LocalScripts\
metadata_services=cloudbaseinit.metadata.services.ovfservice.OvfService
plugins=cloudbaseinit.plugins.common.mtu.MTUPlugin,cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,cloudbaseinit.plugins.windows.extendvolumes.ExtendVolumesPlugin
allow_reboot=false
stop_service_on_exit=false
check_latest_version=false
"@

mEcho "Creating file $confPath $confFile "
New-Item -Path $confPath -Name $confFile -ItemType File -Force -Value $confContent | Out-Null

$confFile = 'cloudbase-init.conf'
$confPath = "$WIN64_CLOUDINIT_DIR\conf\"
$confContent = @"
[DEFAULT]
username=$AdminUser
groups=$AdminGroup
inject_user_password=true
first_logon_behaviour=no
config_drive_raw_hhd=true
config_drive_cdrom=true
config_drive_vfat=true
bsdtar_path=$WIN64_CLOUDINIT_DIR\bsdtar.exe
mtools_path=$WIN64_CLOUDINIT_DIR\bin
verbose=true
debug=true
logdir=$WIN64_CLOUDINIT_DIR\log
logfile=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=$WIN64_CLOUDINIT_DIR\LocalScripts
metadata_services=cloudbaseinit.metadata.services.ovfservice.OvfService
plugins=cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,cloudbaseinit.plugins.windows.setuserpassword.SetUserPasswordPlugin,cloudbaseinit.plugins.common.sshpublickeys.SetUserSSHPublicKeysPlugin,cloudbaseinit.plugins.common.userdata.UserDataPlugin
"@

mEcho "Creating file $confPath $confFile "
New-Item -Path $confPath -Name $confFile -ItemType File -Force -Value $confContent | Out-Null

Start-Process sc.exe -ArgumentList "config cloudbase-init start= delayed-auto" -wait 
Start-Process sc.exe -ArgumentList "start cloudbase-init " -wait 

# mEcho "Deleting file cloudbase-init-unattend.conf "
# Remove-Item -Path ($confPath + "cloudbase-init-unattend.conf") -Confirm:$false 
# mEcho "Deleting file Unattend.xml"
# Remove-Item -Path ($confPath + "Unattend.xml") -Confirm:$false 
Remove-Item C:\Windows\Temp\CloudbaseInitSetup_x64.msi -Confirm:$false

