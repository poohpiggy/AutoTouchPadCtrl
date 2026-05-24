# 自动提权
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 停止所有相关后台进程
Stop-Process -Name powershell -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match "AutoTouchPadCtrl" }

# 删除开机自启项
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AutoTouchPadCtrl" -ErrorAction SilentlyContinue

# 删除脚本文件
Remove-Item "C:\Windows\AutoTouchPadCtrl.ps1" -Force -ErrorAction SilentlyContinue

# 重新启用触控板，确保恢复正常
Enable-PnpDevice "ACPI\ELAN0000\0" -Confirm:$false -ErrorAction SilentlyContinue

Write-Host "`n[√] 卸载完成！触控板已恢复正常`n"
Read-Host "按回车关闭窗口"