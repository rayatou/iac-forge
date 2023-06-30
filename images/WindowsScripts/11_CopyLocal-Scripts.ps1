$SHELL_DIR=$env:SHELL_DIR
. "$SHELL_DIR\scLib.ps1"

mEcho "Copy $confPath $confFile "
Copy-Item -Path A:\* -Destination "$WIN64_CLOUDINIT_DIR\LocalScripts" -PassThru

$cmdFile = '99_CleanUp.cmd'
$cmdPath = "$WIN64_CLOUDINIT_DIR\LocalScripts\"
$cmdContent = @"
@echo OFF

CD "$confPath"
DEL "AC-*.*" /F
"@

mEcho "Creating file $cmdPath $cmdFile "
New-Item -Path $cmdPath -Name $cmdFile -ItemType File -Force -Value $cmdContent | Out-Null
