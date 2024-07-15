
[![made-with-powershell](https://img.shields.io/badge/PowerShell-1f425f?logo=Powershell)](https://microsoft.com/PowerShell)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Disclaimer

**WARNING:** I do **NOT** take responsibility for what may happen to your system! Run scripts at your own risk!

## Goals

These scripts are intended to configure Windows from a new installation with my personal configuration.

## Usage

If you want to execute remote<br>
1. Open powershell command with administrative rights.
2. Set-ExecutionPolicy Bypass -Scope Process -Force;
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

## Meslo Font

Meslo-Font on [andreberg's repo](https://github.com/andreberg/Meslo-Font)

## Fira Code Font

FiraCode on [tonsky's repo](https://github.com/tonsky/FiraCode)

## Credits

Thank you to [valdecircarvalho](https://github.com/valdecircarvalho), [Sycnex](https://github.com/Sycnex), [Disassembler0](https://github.com/Disassembler0)
