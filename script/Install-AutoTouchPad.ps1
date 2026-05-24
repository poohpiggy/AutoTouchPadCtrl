# 自动提权
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$code = @'
while(1) {
    try {
        # 读取硬件翻转模式值
        $mode = Get-ItemPropertyValue "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" ConvertibleSlateMode
    } catch { 
        $mode = 1
    }

    # 0 = 平板模式 → 禁用触摸板
    # 1 = 笔记本模式 → 启用触摸板
    if ($mode -eq 0) {
        Disable-PnpDevice "ACPI\ELAN0000\0" -Confirm:$false -ErrorAction SilentlyContinue
    } else {
        Enable-PnpDevice "ACPI\ELAN0000\0" -Confirm:$false -ErrorAction SilentlyContinue
    }
    Start-Sleep 1
}
'@

$dest = "C:\Windows\AutoTouchPadCtrl.ps1"
$code | Out-File $dest -Encoding UTF8 -Force

# 开机自启
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AutoTouchPadCtrl" -Value "powershell -WindowStyle Hidden -File `"$dest`"" -Force

# 启动后台进程
Start-Process powershell.exe "-WindowStyle Hidden -File `"$dest`""

Write-Host "`n[√] 安装成功`n"
Read-Host "按回车关闭"