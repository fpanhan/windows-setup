# Self elevate
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	Exit
}

Write-Host "Creating Powershell profile..."
if (Test-Path $PROFILE) {
	Remove-Item -Path $PROFILE -Force
}

$templateProfile = @'
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
'@

if (!(Test-Path -Path $PROFILE ))
{
	Write-Host "Configuring oh-my-posh..."
	New-Item -Type File -Path $PROFILE -Force
	Set-Content -Path $PROFILE -Value $templateProfile -Force
}


Write-Host "Creating Windows Terminal profile..."
[string]$windowsTerminalFolderName = Get-ChildItem -Recurse "$env:LocalAppData\Packages\" | Where-Object {$_.Name -like "Microsoft.WindowsTerminal*" } | Select $_.Name

[string]$windowsTerminalPath = "$env:LocalAppData\Packages\$windowsTerminalFolderName\LocalState"
[string]$windowsTerminalSettings = "$windowsTerminalPath\settings.json"

if (Test-Path $windowsTerminalPath) {
	if (Test-Path $windowsTerminalSettings) {
		Remove-Item -Path $windowsTerminalSettings -Force
	}
}

try {
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fpanhan/windows-setup/main/windows_terminal/settings.json" -OutFile $windowsTerminalSettings
}
catch {
	Write-Host "An error occurred while downloading Windows Terminal profile: $_"
}
finally {
	Write-Host "Download Windows Terminal profile completed."
}

Write-Host "Installing nerd-fonts..."
choco feature enable -n=allowGlobalConfirmation

choco install -y nerd-fonts-hack --force
choco install -y nerd-fonts-firacode --force
choco install -y nerd-fonts-meslo --force

choco feature disable -n=allowGlobalConfirmation
