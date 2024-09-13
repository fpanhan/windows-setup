oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression

if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force -SkipPublisherCheck
}
if (!(Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck
}
if (!(Get-Module -ListAvailable -Name Posh-Git)) {
    Install-Module -Name Posh-Git -Force -SkipPublisherCheck
}
if (!(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
    Install-Module PSWindowsUpdate -Force -AllowClobber -Verbose -AcceptLicense -Confirm:$false
}

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

function touch($command) {
    New-Item -Path $command -ItemType File | Out-Null | Write-Host Created $command
}

function rm($command) {
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

function System-Update() {
    Write-Host "Updating Windows..." -ForegroundColor "Yellow"
    Get-WindowsUpdate -Severity Important -AcceptAll -Install -IgnoreReboot
    Write-Host "Updating Existing Winget Packs..." -ForegroundColor "Yellow"
    winget upgrade --all --force --disable-interactivity --accept-source-agreements --accept-package-agreements --include-unknown
    Write-Host "Updating Existing Powershell Modules..." -ForegroundColor "Yellow"
    Update-Module
    #Write-Host "Updating Help..." -ForegroundColor "Yellow"
    #Update-Help
    Write-Host "Updating npm packs..." -ForegroundColor "Yellow"
    npm install npm -g
    npm update -g
}

function Empty-RecycleBin {
    $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
    $RecBin.Items() | %{Remove-Item $_.Path -Recurse -Confirm:$false}
}

# Extract a .zip file
function Unzip-File {
    <#
    .SYNOPSIS
       Extracts the contents of a zip file.

    .DESCRIPTION
       Extracts the contents of a zip file specified via the -File parameter to the location specified via the -Destination parameter.

    .PARAMETER File
        The zip file to extract. This can be an absolute or relative path.

    .PARAMETER Destination
        The destination folder to extract the contents of the zip file to.

    .PARAMETER ForceCOM
        Switch parameter to force the use of COM for the extraction even if the .NET Framework 4.5 is present.

    .EXAMPLE
       Unzip-File -File archive.zip -Destination .\d

    .EXAMPLE
       'archive.zip' | Unzip-File

    .EXAMPLE
        Get-ChildItem -Path C:\zipfiles | ForEach-Object {$_.fullname | Unzip-File -Destination C:\databases}

    .INPUTS
       String

    .OUTPUTS
       None

    .NOTES
       Inspired by:  Mike F Robbins, @mikefrobbins

       This function first checks to see if the .NET Framework 4.5 is installed and uses it for the unzipping process, otherwise COM is used.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$File,

        [ValidateNotNullOrEmpty()]
        [string]$Destination = (Get-Location).Path
    )

    $filePath = Resolve-Path $File
    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

    if (($PSVersionTable.PSVersion.Major -ge 3) -and
       ((Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -like "4.5*" -or
       (Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -like "4.5*")) {

        try {
            [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
            [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    } else {
        try {
            $shell = New-Object -ComObject Shell.Application
            $shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    }
}

function help() {
    Write-Host "Custom functions created by Me" -ForegroundColor Green
    Write-Host "   ‣ work - go to work directory"
    Write-Host "   ‣ touch - creates new file"
    Write-Host "   ‣ rm - removes file and directory"
    Write-Host "   ‣ mcd - creates a directory and enters it, a combination of mkdir and cd"
    Write-Host "   ‣ npp - start Notepad++"
    Write-Host "   ‣ changeTheme - change to random theme of oh-my-posh"
    Write-Host "   ‣ System-Update - Update NPM, and their installed packages"
    Write-Host "   ‣ Empty-RecycleBin - Empty the Recycle Bin on all drives"
    Write-Host "   ‣ Unzip-File - Extract a .zip file - Unzip-File -File archive.zip -Destination C:\temp"
}
