# 自动提权
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Get-CimInstance Win32_Process | Where-Object {
    $_.CommandLine -match "AutoTouchPadCtrl\.ps1"
} | ForEach-Object {
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
}

Remove-Item "C:\Windows\AutoTouchPadCtrl.ps1" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AutoTouchPadCtrl" -Force -ErrorAction SilentlyContinue

Write-Host "[√] 卸载成功"
Read-Host "回车关闭窗口"