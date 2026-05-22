# 自动管理员提权
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 找到并结束运行中的 AutoTouchPadCtrl 进程
Get-WmiObject Win32_Process | Where-Object {
    $_.CommandLine -like "*AutoTouchPadCtrl.ps1*"
} | ForEach-Object {
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
}

# 删除文件和注册表项
Remove-Item "C:\Windows\AutoTouchPadCtrl.ps1" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AutoTouchPadCtrl" -Force -ErrorAction SilentlyContinue

Write-Host "[√] 卸载成功"
Read-Host "回车关闭窗口"