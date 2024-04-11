Write-Host "Installing nerd-fonts..."

if (!(Test-Path -Path "C:\temp" ))
{
	New-Item -Path "C:\temp" -ItemType Directory -Force | Out-Null
}
if (!(Test-Path -Path "C:\temp\fonts" ))
{
	New-Item -Path "C:\temp\fonts" -ItemType Directory -Force | Out-Null
}
else
{
	Remove-Item -Path "C:\temp\fonts" -Force -Recurse -Confirm:$false
	New-Item -Path "C:\temp\fonts" -ItemType Directory -Force | Out-Null
}

& git clone https://github.com/ryanoasis/nerd-fonts.git C:\temp\fonts
& Invoke-Expression C:\temp\fonts\nerd-fonts\install.ps1 FiraCode, Hack, Meslo, Caskaydiacove, Terminus

$templateProfile = @'
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
'@

if (!(Test-Path -Path $PROFILE ))
{
	Write-Host "Configuring oh-my-posh..."
	New-Item -Type File -Path $PROFILE -Force
	Set-Content -Path $PROFILE -Value $templateProfile -Force
}
