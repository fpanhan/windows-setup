<div align = "center">

<h1><a href="https://github.com/fpanhan/windows-setup">win2k</a></h1>

<a href="https://github.com/fpanhan/windows-setup/blob/main/LICENSE">
<img alt="License" src="https://img.shields.io/github/license/fpanhan/windows-setup?style=flat&color=eee&label="> </a>

<a href="microsoft.com/PowerShell">
<img alt="PowerShell" src="https://img.shields.io/badge/PowerShell-1f425f?logo=Powershell"> </a>

<a href="https://github.com/fpanhan/windows-setup/graphs/contributors">
<img alt="People" src="https://img.shields.io/github/contributors/fpanhan/windows-setup?style=flat&color=ffaaf2&label=People"> </a>

<a href="https://github.com/fpanhan/windows-setup/stargazers">
<img alt="Stars" src="https://img.shields.io/github/stars/fpanhan/windows-setup?style=flat&color=98c379&label=Stars"></a>

<a href="https://github.com/fpanhan/windows-setup/network/members">
<img alt="Forks" src="https://img.shields.io/github/forks/fpanhan/windows-setup?style=flat&color=66a8e0&label=Forks"> </a>

<a href="https://github.com/fpanhan/windows-setup/watchers">
<img alt="Watches" src="https://img.shields.io/github/watchers/fpanhan/windows-setup?style=flat&color=f5d08b&label=Watches"> </a>

<a href="https://github.com/fpanhan/windows-setup/pulse">
<img alt="Last Updated" src="https://img.shields.io/github/last-commit/fpanhan/windows-setup?style=flat&color=e06c75&label="> </a>




## Disclaimer

**WARNING:** I do **NOT** take responsibility for what may happen to your system! Run scripts at your own risk!

## Goals

These scripts are intended to configure Windows from a new installation (new/empty machine) with my personal configuration.

## Usage

If you want to execute remote<br>
1. Open powershell command with administrative rights.
2. Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
3. Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fpanhan/windows-setup/main/1-bootstrap.ps1"))

If you want to execute locally<br>
1. Clone or download this repo.
2. Open powershell command with administrative rights.
3. Navigate to the correct directory.
4. Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force;
5. PS C:\temp\windows-setup> .\2-script-install.ps1
6. PS C:\temp\windows-setup> .\2.1-configuring.ps1
7. PS C:\temp\windows-setup> .\3-customizations.ps1
8. PS C:\temp\windows-setup> .\4-decrapfy.ps1

## Tweaks

Allow Insecure Localhost link

Edge: edge://flags/#allow-insecure-localhost
Chrome: chrome://flags/#allow-insecure-localhost
Firefox: about:config and then search for "allowInsecureFromHTTPS"

## Meslo Font

Meslo-Font on [andreberg's repo](https://github.com/andreberg/Meslo-Font)

## Fira Code Font

FiraCode on [tonsky's repo](https://github.com/tonsky/FiraCode)

## Credits

Thank you to [valdecircarvalho](https://github.com/valdecircarvalho), [Sycnex](https://github.com/Sycnex), [Disassembler0](https://github.com/Disassembler0)

</div>
