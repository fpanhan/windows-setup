oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force -SkipPublisherCheck
}
if (!(Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck
}

Import-Module -Name Terminal-Icons -Force
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineOption -ShowToolTips
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

function changeTheme() {
    $themes = "$env:LocalAppData\Programs\oh-my-posh\themes\"
    $theme = $args[0]
    if($null -eq $theme) {
        $theme = Get-ChildItem $themes -name | Select-Object -index $(Random $((Get-ChildItem $themes).Count))
    } else {
        $theme = $theme + ".omp.json"
    }
    Write-Output "Using $theme"
    oh-my-posh init pwsh --config "$themes$theme" | Invoke-Expression
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

function work {
    cd "C:\git\$args"
}

function help() {
    Write-Host "Custom functions created by Me" -ForegroundColor Green
    Write-Host "   ‣ work - go to work directory"
	Write-Host "   ‣ touch - creates new file"
	Write-Host "   ‣ rm - removes file and directory"
	Write-Host "   ‣ mcd - creates a directory and enters it, a combination of mkdir and cd"
    Write-Host "   ‣ npp - start Notepad++"
    Write-Host "   ‣ changeTheme - change to random theme of oh-my-posh"
}
