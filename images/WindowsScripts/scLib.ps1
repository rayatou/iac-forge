$SCRIPT_DIR = "A:\"
. "$SCRIPT_DIR\scVars.ps1"

$CST_ERROR_ACL="ERROR 1344 (0x00000540)"
$CST_ERROR_FILE_ACCESS="ERROR 1920 (0x00000780)"

$DATE_NOW   = Get-Date -Format yyyy_MM_d_HH

$CONF_DIR   = $SCRIPT_DIR + "\Conf"
$TEMP_DIR    = $SCRIPT_DIR + "\Temp"
$LOG_DIR    = $SCRIPT_DIR + "\Logs"

$JobMax = 100
$JobSleep = 120

$mProgram   = "Main"
$mModule    = "Main"

function mEcho {
  param(
    $namedOptional = "default",
    [Parameter(ValueFromRemainingArguments = $true, Position=1)]
    $message
  )

  write-host "## $mProgram`t| $mModule`t>> $message"
}

function mEchoIntense {
  param(
    $namedOptional = "default",
    [Parameter(ValueFromRemainingArguments = $true, Position=1)]
    $message
  )

  write-host ""
  write-host "#######################################"
  write-host "## $mProgram`t| $mModule`t>> $message"
  write-host "#######################################"
  write-host ""
}

function Get-MrPSVersion {
  write-host "#######################################"
  write-host "## Operating System  : $((Get-WmiObject -class Win32_OperatingSystem).Caption)"
  write-host "## PowerShell Version: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
  write-host "#######################################"
      
}
