# Self elevate
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	Exit
}

Write-Host "Creating Powershell profile..."
if (Test-Path -Path $PROFILE.AllUsersAllHosts) {
	Remove-Item -Path $PROFILE.AllUsersAllHosts -Force
}

Install-Module -Name Terminal-Icons -Repository PSGallery -Force -AllowClobber
Install-Module -Name z -Force -AllowClobber
Install-Module -Name PSReadLine -Force -SkipPublisherCheck -AllowClobber
Install-Module -Name PSFzf -Force -AllowClobber

Update-Module

#PowerShell
try {
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fpanhan/windows-setup/main/config/powershell/Profile.ps1" -OutFile "$PROFILE.AllUsersAllHosts"
}
catch {
	Write-Host "An error occurred while downloading Windows Powershell 7 profile: $_"
}
finally {
	Write-Host "Download Windows Powershell 7 profile completed."
}

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
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fpanhan/windows-setup/main/config/windows_terminal/settings.json" -OutFile $windowsTerminalSettings
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

Write-Host "Installing fonts via chocolatey..."
choco feature enable -n=allowGlobalConfirmation
choco install -y nerd-fonts-hack
choco install -y nerd-fonts-firacode
choco install -y nerd-fonts-meslo
choco install -y nerd-fonts-cascadiacode
choco feature disable -n=allowGlobalConfirmation

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


Write-Host "Copying vscode settings..."
try {
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fpanhan/windows-setup/main/config/vscode/settings.json" -OutFile "$env:AppData\Code\User\settings.json"
}
catch {
	Write-Host "An error occurred while downloading vscode settings: $_"
}
finally {
	Write-Host "Download vscode settings completed."
}


Write-Host "Installing vscode extensions..."

# Formatting and Rules
code --install-extension dbaeumer.vscode-eslint --force
code --install-extension esbenp.prettier-vscode --force
code --install-extension aaron-bond.better-comments --force

# HTML and CSS
code --install-extension formulahendry.auto-rename-tag --force
code --install-extension naumovs.color-highlight --force
code --install-extension anteprimorac.html-end-tag-labels --force

# Git
code --install-extension github.vscode-pull-request-github --force
code --install-extension eamodio.gitlens-insiders --force

# .NET
code --install-extension ms-dotnettools.csharp --force
code --install-extension visualstudioexptteam.vscodeintellicode --force

# Test Runners
code --install-extension ms-playwright.playwright --force

# Markdown
code --install-extension yzhang.markdown-all-in-one --force
code --install-extension davidanson.vscode-markdownlint --force

# Rest Client
code --install-extension rangav.vscode-thunder-client --force

# Miscellaneous
code --install-extension github.copilot --force
code --install-extension vscode-icons-team.vscode-icons --force


code --install-extension ms-dotnettools.csharp --force
code --install-extension ms-dotnettools.vscode-dotnet-runtime --force
code --install-extension ms-vscode-remote.remote-containers --force
code --install-extension ms-vscode.live-server --force
