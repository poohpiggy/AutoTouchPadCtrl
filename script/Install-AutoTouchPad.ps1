if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$dest = "$env:ProgramData\AutoTouchPadCtrl.ps1"

$code = @'
while(1) {
    try {
        $mode = Get-ItemPropertyValue "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" ConvertibleSlateMode
    } catch {
        $mode = 1
    }
    if ($mode -eq 0) {
        Disable-PnpDevice "ACPI\ELAN0000\0" -Confirm:$false -ErrorAction SilentlyContinue
    } else {
        Enable-PnpDevice "ACPI\ELAN0000\0" -Confirm:$false -ErrorAction SilentlyContinue
    }
    Start-Sleep 1
}
'@

$code | Out-File $dest -Encoding UTF8 -Force

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$dest`""
$trigger = New-ScheduledTaskTrigger -AtLogon
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName "AutoTouchPadCtrl" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force

Start-ScheduledTask -TaskName "AutoTouchPadCtrl"

Write-Host "`n[√] 安装完成`n"
Read-Host "回车关闭"