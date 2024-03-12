# based on https://github.com/valdecircarvalho/windows-setup/

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
    Start-Sleep 1
    Write-Host "                                               3"
    Start-Sleep 1
    Write-Host "                                               2"
    Start-Sleep 1
    Write-Host "                                               1"
    Start-Sleep 1
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

$ErrorActionPreference = 'silentlycontinue'

Write-Output  "Executing Install script..."
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fpanhan/windows-setup/master/2-script-install.ps1'))

Start-Sleep -s 5

Write-Output  "Executing Customization script..."
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fpanhan/windows-setup/master/3-customizations.ps11'))

Start-Sleep -s 5

Write-Output  "Executing decrapfy Windows script..."
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fpanhan/windows-setup/master/4-decrapfy.ps1'))

Start-Sleep -s 5

Write-Output  "Restarting computer..."

Read-Host -Prompt "Configuration is done, restart is needed, press [ENTER] to restart computer."
$key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host "Restarting..."
#Restart-Computer