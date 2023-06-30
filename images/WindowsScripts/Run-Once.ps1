$SHELL_DIR=$env:SHELL_DIR
. "$SHELL_DIR\scLib.ps1"

$execute = "$WIN64_CLOUDINIT_DIR\LocalScripts\"
$argument = 
$working_directory = "$WIN64_CLOUDINIT_DIR\LocalScripts\"
$task_name = "InstallSQLServer"
$description = "SQL Server Installation"

$get_task = Get-ScheduledTask $task_name -ErrorAction SilentlyContinue
if ($get_task) {
    Write-Output "changed=no comment='Task name already exists, task not added.'"
}
else {
    $action = New-ScheduledTaskAction -Execute $execute -Argument $argument -WorkingDirectory $working_directory
    $trigger =  New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -Action $action -Trigger $trigger -User 'SYSTEM' -TaskName $task_name -Description $description
    Write-Output "changed=yes comment='Task added succesfully.'"
}