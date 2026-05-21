# 自动提权
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$code = @'
while(1) {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell"
    $devId = "ACPI\ELAN0000\0"
    static $lastMode = $null

    try {
        $nowMode = (Get-ItemProperty $regPath -Name TabletMode -EA SilentlyContinue).TabletMode
    } catch {
        $nowMode = 0
    }

    if($nowMode -ne $lastMode){
        if($nowMode -eq 1){
            Disable-PnpDevice -InstanceId $devId -Confirm:$false -ErrorAction SilentlyContinue
        } else {
            Enable-PnpDevice -InstanceId $devId -Confirm:$false -ErrorAction SilentlyContinue
        }
        $lastMode = $nowMode
    }
    Start-Sleep 2
}
'@

$dest = "C:\Windows\AutoTouchPadCtrl.ps1"
$code | Out-File $dest -Encoding UTF8 -Force

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AutoTouchPadCtrl" -Value "powershell -WindowStyle Hidden -File `"$dest`"" -Force
Start-Process powershell.exe "-WindowStyle Hidden -File `"$dest`""

Write-Host "`n[√] 安装完成，已后台常驻并开机自启`n"
Read-Host "回车关闭窗口"
