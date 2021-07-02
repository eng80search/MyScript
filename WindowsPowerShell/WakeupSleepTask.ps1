$script = '$signature = @"
[DllImport("powrprof.dll")]
public static extern bool SetSuspendState(bool Hibernate,bool ForceCritical,bool DisableWakeEvent);
"@
$func = Add-Type -memberDefinition $signature -namespace "Win32Functions" -name "SetSuspendStateFunction" -passThru
$func::SetSuspendState($false,$true,$false)'

$bytes = [System.Text.Encoding]::Unicode.GetBytes($script)
$encodedCommand = [Convert]::ToBase64String($bytes)

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-encodedCommand $encodedCommand"

$trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 1 -At 08:09
Register-ScheduledTask -TaskName "Sleep" -Action $action -Trigger $trigger -Force

$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c echo hello"
$settings = New-ScheduledTaskSettingsSet -WakeToRun
$trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 1 -At 08:12
Register-ScheduledTask -TaskName "WakeUp" -Action $action -Settings $settings -Trigger $trigger -Force