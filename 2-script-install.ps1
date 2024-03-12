# Self elevate
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	Exit
}

Write-Information "Baixando o WinGet and its dependencies..."
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
Write-Information "Installing WinGet and its dependencies..."
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle


Write-Output "Installing Apps"
$apps = @(
	@{name = "Google.Chrome" },
    @{name = "7zip.7zip" },
	@{name = "cURL.cURL" },
    @{name = "Adobe.Acrobat.Reader.64-bit" },
    @{name = "Git.Git" },
	@{name = "GitHub.GitLFS" },
	@{name = "GitExtensionsTeam.GitExtensions" },
	@{name = "Git.Git" },
    @{name = "Greenshot.Greenshot" },
    @{name = "JanDeDobbeleer.OhMyPosh" },
    @{name = "Microsoft.dotnet" },
    @{name = "Microsoft.PowerShell" },
    @{name = "Microsoft.PowerToys" },
    @{name = "Microsoft.WindowsTerminal" },
    @{name = "Notepad++.Notepad++" },
    @{name = "OpenJS.NodeJS" },
	@{name = "PostgreSQL.PostgreSQL" },
	@{name = "dbeaver.dbeaver" },
    @{name = "Zoom.Zoom" }
);

Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
	Start-Sleep -s 1
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-Host "Installing: " $app.name
        winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name
    }
    else {
        Write-Host "Skipping: " $app.name " (already installed)"
    }
	RefreshEnv
		Start-Sleep -s 1
}

$windowsfeature = @(
    @{name = "NetFX3" },
	@{name = "IIS-WebServer" },
	@{name = "IIS-ManagementConsole" },
	@{name = "IIS-ManagementService" },
	@{name = "IIS-ASPNET" },
	@{name = "IIS-ASPNET45" },
    @{name = "Containers" },
    @{name = "HypervisorPlatform" },
    @{name = "Microsoft-Windows-Subsystem-Linux" },
    @{name = "VirtualMachinePlatform" },
    @{name = "SimpleTCP" },
    @{name = "Microsoft-Hyper-V-All" },
    @{name = "Containers-DisposableClientVM" },
    @{name = "Microsoft-Hyper-V-Tools-All" },
    @{name = "Microsoft-Hyper-V" },  
    @{name = "TelnetClient" },
    @{name = "Windows-Defender-Default-Definitions" },
    @{name = "Microsoft-Hyper-V-Management-PowerShell" },
    @{name = "Microsoft-Hyper-V-Services" },
    @{name = "Microsoft-Hyper-V-Hypervisor" },      
    @{name = "Microsoft-Hyper-V-Management-Clients" },
    @{name = "Windows-Defender-ApplicationGuard" },
    @{name = "NFS-Administration" },
    @{name = "ClientForNFS-Infrastructure" },
    @{name = "ServicesForNFS-ClientOnly" }
)

Write-Host "Installing Windows Features..."

Foreach ($wf in $windowsfeature) {
    Write-Host  "Installing"  $wf.name "..."
    Start-Sleep -s 1
    Enable-WindowsOptionalFeature -Online -FeatureName $wf.name -All
    RefreshEnv
    Start-Sleep -s 1
}
