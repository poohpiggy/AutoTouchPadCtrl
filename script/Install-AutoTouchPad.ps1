# 自动提权
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$code = @'
while(1) {
    try {
        $s = Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AutoRotation" Enable
    } catch { $s = 0 }
    if ($s -eq 1) {
        Disable-PnpDevice "ACPI\ELAN0000\0" -Confirm:$false -ErrorAction SilentlyContinue
    } else {
        Enable-PnpDevice "ACPI\ELAN0000\0" -Confirm:$false -ErrorAction SilentlyContinue
    }
    Start-Sleep 1
}
'@

$dest = "C:\Windows\AutoTouchPadCtrl.ps1"
$code | Out-File $dest -Encoding UTF8 -Force

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AutoTouchPadCtrl" -Value "powershell -WindowStyle Hidden -File `"$dest`"" -Force
Start-Process powershell.exe "-WindowStyle Hidden -File `"$dest`""

Write-Host "`n[√] 安装完成，已后台常驻并开机自启`n"
Read-Host "回车关闭窗口"