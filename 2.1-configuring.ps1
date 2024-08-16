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

Write-Host "Installing fonts..."
#choco feature enable -n=allowGlobalConfirmation
#choco install -y nerd-fonts-hack
#choco install -y nerd-fonts-firacode
#choco install -y nerd-fonts-meslo
#choco feature disable -n=allowGlobalConfirmation

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
