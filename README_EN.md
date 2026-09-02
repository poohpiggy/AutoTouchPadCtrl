# AutoTouchPadCtrl 

Touchpad automatic management tool for Chromebook third\-party drivers

Designed for convertible Chromebook running Windows with third-party ported drivers  (Lenovo Flex 5 Chromebook/Google Akemi) . These devices lack complete official adaptation, and the built\-in driver cannot link touchpad with tablet mode\. The touchpad stays active after flipping, causing accidental clicks and random cursor movement during touch and stylus use\.

This self\-tweaked script disables the touchpad automatically when entering tablet mode and restores it while switching back to desktop mode, fixing common daily usage issues\.

## Version Info

Current Version: **V4**
Judgment depends on ConvertibleSlateMode status\. Hardware posture detection will be added in future updates for more accurate recognition without UI restriction\.

## Features

- Compatible with third\-party driver environment, compensates missing official touchpad linkage

- State cache mechanism, operates only on mode change to prevent lag

- Pure PowerShell script, no extra software, low system resource consumption

- Built\-in privilege request, one\-click easy installation

- Auto startup supported, permanent effect after single setup

- Takes effect immediately without system reboot

- Complete uninstall script, clean removal with no leftover files

## Working Principle

Read tablet mode status from system registry
`HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl - ConvertibleSlateMode`

- Value 1: Tablet Mode disabled, touchpad resumes normal use

- Value 0: Tablet Mode enabled, touchpad disabled automatically

The script records previous state and avoids unnecessary repeated operations\.

## Supported Devices

- Chromebook installed with Windows 10 / Windows 11

- Only for devices using third\-party customized drivers

- Default compatible with ELAN touchpad, ID: `ACPI\\ELAN0000\\0`

## File Description

|File Name|Function|
|---|---|
|Install\-AutoTouchPad\.ps1|One\-click installation, authorize access, add startup entry, run silently|
|Uninstall\-AutoTouchPad\.ps1|Full removal, stop background process, delete files and registry settings|

## Usage Guide

### Installation

1. Download both script files

2. Right\-click and run installer with PowerShell

3. Grant administrator permission

4. Start using once installation finishes

### Uninstallation

1. Launch uninstall script via PowerShell

2. All related processes and configurations will be cleared automatically

3. Touchpad reverts to system default state

## Custom Adaptation

Modify device ID manually for different touchpad hardware

1. Open Device Manager and locate touchpad device

2. Right\-click to view properties and details

3. Copy device instance path and replace the default ID inside script

## Additional Note

This tool is developed specially for Chromebook running Windows with unofficial drivers\. Later updates will adopt hardware detection logic, free from tablet interface and screen rotation limits to fit more usage scenarios\.
