if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Stop-Process -Name powershell -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match "AutoTouchPadCtrl" }

Unregister-ScheduledTask -TaskName "AutoTouchPadCtrl" -Confirm:$false -ErrorAction SilentlyContinue

Remove-Item "$env:ProgramData\AutoTouchPadCtrl.ps1" -Force -ErrorAction SilentlyContinue

Enable-PnpDevice "ACPI\ELAN0000\0" -Confirm:$false -ErrorAction SilentlyContinue

Write-Host "`n[√] 卸载完成`n"
Read-Host "回车关闭"