# Edge Impulse CLI Install Scripts

## Quick Start

### Windows

Open a Powershell window **with Administrator privileges** and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iwr -Uri "https://raw.githubusercontent.com/edgeimpulse/ei-install-scripts/main/install-windows.ps1" -Outfile install.ps1; iex .\install.ps1; del .\install.ps1
```

## Using the repo

[Install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for your OS, then clone this repo to your computer from a command line terminal (or from a PowerShell terminal on Windows):

```sh
git clone https://github.com/edgeimpulse/ei-install-scripts.git
cd ei-install-scripts
```

Or, [download this repository as a `.zip` file](https://github.com/edgeimpulse/ei-install-scripts/archive/refs/heads/main.zip) and unzip it locally, then from a command line terminal (or from a PowerShell terminal on Windows):

```sh
cd ei-install-scripts-main
```

### Linux/Ubuntu/Raspbian, etc.

From a command line terminal run:

```sh
. ./install-linux.sh
```

### macOS

From a command line terminal run:

```sh
. ./install-mac.sh
```

### Windows

From a PowerShell terminal run:

```powershell
Start-Process powershell.exe -ArgumentList ("-NoExit",("cd {0}" -f (Get-Location).path)) -Verb RunAs
<# Click Yes, then from the new PowerShell window, run: #>
.\install-windows.ps1
```

## Troubleshooting

If you get the following error from `.\install-windows.ps1`:

```powershell
PS C:\Users\jplun\Repos\ei-install-scripts> .\install-windows.ps1
.\install-windows.ps1 : File C:\Users\jplun\Repos\ei-install-scripts\install-windows.ps1 cannot be loaded because
running scripts is disabled on this system. For more information, see about_Execution_Policies at
https:/go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ .\install-windows.ps1
+ ~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
```

Then instead run the script from an administrator PowerShell terminal with the following command: `powershell -ExecutionPolicy Bypass -File .\install-windows.ps1`

## Contributing to the repo

This repo uses github actions to run installer tests on windows (and soon) Mac and Linux. Tests run on every pull-request but you can also run tests on every push if you name your branch as `win-test*`, `mac-test*` or `linux-test*` respectively.