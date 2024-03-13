# Self elevate
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
	Exit
}

Write-Information "Downloading and installing WinGet and its dependencies..."
if (!(Get-AppPackage -AllUsers).Name -like "*Microsoft.VCLibs*") {
	if (!(Test-Path "Microsoft.VCLibs.x64.14.00.Desktop.appx")) {
		Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
	}
	
	Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
}

if (!(Get-AppPackage -AllUsers).Name -like "*Microsoft.UI.Xaml*") {
	if (!(Test-Path "Microsoft.UI.Xaml.2.7.x64.appx")) {
		Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
	}
	
	Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
}

if (!(Get-AppxPackage -Name Microsoft.DesktopAppInstaller)) {
	if (!(Test-Path "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle")) {
		Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
	}
	
	Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

Write-Output "Installing Apps"
$apps = @(
	@{name = "Google.Chrome" },
	#@{name = "Mozilla.Firefox" },
	#@{name = "Opera.Opera" },
	#@{name = "Opera.OperaGX" },
	#@{name = "Brave.Brave" },
	@{name = "voidtools.Everything" },
	@{name = "Mythicsoft.AgentRansack" },
	@{name = "Toinane.Colorpicker" },
	@{name = "IrfanSkiljan.IrfanView" },
	@{name = "IrfanSkiljan.IrfanView.PlugIns" },
	@{name = "7zip.7zip" },
	@{name = "cURL.cURL" },
	@{name = "Adobe.Acrobat.Reader.64-bit" },
	@{name = "Git.Git" },
	@{name = "GitHub.GitLFS" },
	@{name = "GitExtensionsTeam.GitExtensions" },
	@{name = "Git.Git" },
	@{name = "Greenshot.Greenshot" },
	@{name = "JanDeDobbeleer.OhMyPosh" },
	@{name = "Postman.Postman" },
	@{name = "SmartBear.SoapUI" },
	#@{name = "Python.Python.3.12" },
	#@{name = "Python.Launcher" },
	#@{name = "VSCodium.VSCodium" },
	#@{name = "Microsoft.VisualStudioCode" },
	#@{name = "Microsoft.VisualStudio.2022.Professional" },
	#@{name = "Microsoft.VisualStudio.2022.Community" },
	#@{name = "Microsoft.VisualStudio.2022.Enterprise" },
	#@{name = "Microsoft.SQLServerManagementStudio" },
	@{name = "Microsoft.UI.Xaml.2.8" },
	@{name = "Microsoft.PowerToys" },
	@{name = "Microsoft.dotnet" },
	@{name = "Microsoft.DotNet.SDK.3_1" },
	@{name = "Microsoft.DotNet.SDK.6" },
	@{name = "Microsoft.DotNet.SDK.7" },
	@{name = "Microsoft.DotNet.SDK.8" },
	#@{name = "Microsoft.DotNet.SDK.9" },
	@{name = "Microsoft.PowerShell" },
	@{name = "Microsoft.PowerToys" },
	@{name = "Microsoft.WindowsTerminal" },
	@{name = "Microsoft.RemoteDesktopClient" },
	@{name = "Notepad++.Notepad++" },
	#@{name = "OpenJS.NodeJS" },
	@{name = "PostgreSQL.PostgreSQL" },
	@{name = "dbeaver.dbeaver" },
	@{name = "Zoom.Zoom" }
);

Foreach ($app in $apps) {
	$listApp = winget list --exact -q $app.name
	Start-Sleep -s 1
	if (![string]::Join("", $listApp).Contains($app.name)) {
		Write-Host "Installing: " $app.name
		winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name
	}
	else {
		Write-Host "Skipping: " $app.name " (already installed)"
	}
	Start-Sleep -s 1
}

$windowsfeature = @(
	@{name = "NetFX3" },
	@{name = "IIS-WebServerRole" },
	@{name = "IIS-WebServer" },
	@{name = "IIS-ManagementConsole" },
	@{name = "IIS-ManagementService" },
	@{name = "IIS-WebServerManagementTools" },
	@{name = "IIS-ManagementConsole" },
	@{name = "IIS-CommonHttpFeatures" },
	@{name = "IIS-HttpRedirect" } ,
	@{name = "IIS-IPSecurity" },
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
	Write-Host "Checking" $wf.name "..."
	Start-Sleep -s 1

	$component = Get-WindowsOptionalFeature -FeatureName $wf.name -Online

	if ($component.State -eq "Disabled" -or $component.State -eq "DisabledWithPayloadRemoved") {
		Write-Host "Installing" $wf.name "..."
		Enable-WindowsOptionalFeature -Online -FeatureName $wf.name -All -NoRestart
	}
	
	Start-Sleep -s 1
}

Write-Output "Update all installed apps"
winget upgrade --all --force --disable-interactivity --accept-source-agreements --accept-package-agreements --include-unknown

Write-Host "Installing all Windows Update..."
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module PSWindowsUpdate -Force -AllowClobber -Verbose -AcceptLicense -Confirm:$false
Get-WindowsUpdate -Severity Important -AcceptAll -Install -IgnoreReboot

#Write-Host "Installing WSL Ubuntu..."
#wsl --install -d Ubuntu
