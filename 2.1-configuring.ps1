# Self elevate
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	Exit
}

Write-Host "Creating Powershell profile..."
if (Test-Path -Path $PROFILE.AllUsersAllHosts) {
	Remove-Item -Path $PROFILE.AllUsersAllHosts -Force
}

$templateProfile = @'
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force -SkipPublisherCheck
}
if (!(Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons -Force
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
try
{
	choco --version
	Write-Host "Chocolatey command present"
	Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
}
catch
{
	Write-Host "Chocolatey doesn't exist" -ForegroundColor Yellow
}
function touch ($command) {
    New-Item -Path $command -ItemType File | Out-Null | Write-Host Created $command
}
function rm ($command) {
    Remove-Item $command -Recurse | Write-Host Removed $command
}
function mcd ($command) {
    mkdir $command | cd $command
}
function npp() {
    Start notepad++
}
function help() {
    Write-Host "Custom functions created by Me" -ForegroundColor Green
	Write-Host "   ‣ touch - creates new file"
	Write-Host "   ‣ rm - removes file and directory"
	Write-Host "   ‣ mcd - creates a directory and enters it, a combination of mkdir and cd"
    Write-Host "   ‣ npp - start Notepad++"
}
'@

if (!(Test-Path -Path $PROFILE.AllUsersAllHosts))
{
	Write-Host "Configuring profile..."
	New-Item -Type File -Path $PROFILE.AllUsersAllHosts -Force
	Set-Content -Path $PROFILE.AllUsersAllHosts -Value $templateProfile -Force
}

Write-Host "Creating Windows Terminal profile..."
[string]$windowsTerminalFolderName = Get-ChildItem -Recurse "$env:LocalAppData\Packages\" | Where-Object {$_.Name -like "Microsoft.WindowsTerminal*" } | Select-Object $_.Name

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

Write-Host "Installing fonts via oh-my-posh..."
oh-my-posh font install meslo
oh-my-posh font install firacode
oh-my-posh font install cascadiacode
<#
Write-Host "Installing fonts via chocolatey..."
choco feature enable -n=allowGlobalConfirmation
choco install -y nerd-fonts-hack
choco install -y nerd-fonts-firacode
choco install -y nerd-fonts-meslo
choco install -y nerd-fonts-cascadiacode
choco feature disable -n=allowGlobalConfirmation
#>
<#
$destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$TempFolder  = "C:\Windows\Temp\Fonts"

New-Item $tempFolder -Type Directory -Force | Out-Null

$fontsSource = @(
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/FiraCode/FiraCode-Bold.ttf"},
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/FiraCode/FiraCode-Light.ttf"},
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/FiraCode/FiraCode-Medium.ttf"},
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/FiraCode/FiraCode-Regular.ttf"},
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/FiraCode/FiraCode-Retina.ttf"},
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/FiraCode/FiraCode-SemiBold.ttf"},
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/Meslo/MesloLGLNerdFont-Bold.ttf"},
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/Meslo/MesloLGLNerdFont-BoldItalic.ttf"},
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/Meslo/MesloLGLNerdFont-Italic.ttf"},
	@{URL = "https://github.com/fpanhan/windows-setup/raw/main/fonts/Meslo/MesloLGLNerdFont-Regular.ttf"}
)

Foreach ($fs in $fontsSource) {
	Write-Host "Downloading font "$fs.URL"..."

	try {
		Invoke-WebRequest -Uri $fs.URL -OutFile $tempFolder
	}
	catch {
		Write-Host "An error occurred while downloading fonts: $_"
	}
	finally {
		Write-Host "Download font "$fs.URL" completed."
	}
}

Get-ChildItem -Path $source -Include "*.ttf","*.ttc","*.otf" -Recurse | ForEach {
    If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
        $font = "$tempFolder\$($_.Name)"
		#Write-Host $font
        Copy-Item $($_.FullName) -Destination $tempFolder
        $destination.CopyHere($font,0x10)
        Remove-Item $font -Force
    }
}
#>