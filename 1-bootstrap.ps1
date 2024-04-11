# based on https://github.com/valdecircarvalho/windows-setup/

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
    Start-Sleep 1
    Write-Host "      3"
    Start-Sleep 1
    Write-Host "      2"
    Start-Sleep 1
    Write-Host "      1"
    Start-Sleep 1
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

$startDate = (Get-Date)

$ErrorActionPreference = 'silentlycontinue'

$OriginalPref = $ProgressPreference # Default is 'Continue'
$ProgressPreference = "SilentlyContinue" # Hide progressbar

Write-Output  "Executing Install script..."
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fpanhan/windows-setup/main/2-script-install.ps1"))

Start-Sleep -s 5

Write-Output  "Executing configuring script..."
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fpanhan/windows-setup/main/2.1-configuring.ps1"))

Start-Sleep -s 5

Write-Output  "Executing Customization script..."
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fpanhan/windows-setup/main/3-customizations.ps11"))

Start-Sleep -s 5

Write-Output  "Executing decrapfy Windows script..."
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fpanhan/windows-setup/main/4-decrapfy.ps1"))

$ProgressPreference = $OriginalPref

$endDate = (Get-Date)
$dif = $($endDate - $startDate)
$minDif = $dif.ToString("mm")
$secDif = $dif.ToString("ss")

Write-Host "Script running " -ForegroundColor Green -NoNewline
Write-Host "$minDif" -ForegroundColor Red -NoNewline
Write-Host " minute(s) and " -ForegroundColor Green -NoNewline
Write-Host "$secDif" -ForegroundColor Red -NoNewline
Write-Host " second(s)!" -ForegroundColor Green

Start-Sleep -s 5
Write-Output  "Restarting computer..."


Read-Host -Prompt "Configuration is done, restart is needed, press [ENTER] to restart computer."
Write-Host "Restarting in..."
Start-Sleep 1
Write-Host "      5"
Start-Sleep 1
Write-Host "      4"
Start-Sleep 1
Write-Host "      3"
Start-Sleep 1
Write-Host "      2"
Start-Sleep 1
Write-Host "      1"
Start-Sleep 1
Restart-Computer