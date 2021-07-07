# Edge Impulse CLI Install Scripts

[Install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for your OS, then clone this repo to your computer from a command line terminal (or from a PowerShell terminal on Windows):

```sh
git clone https://github.com/edgeimpulse/ei-install-scripts.git
cd ei-install-scripts
```

Or, [download this repository as a `.zip` file](https://github.com/edgeimpulse/ei-install-scripts/archive/refs/heads/main.zip) and unzip it locally, then from a command line terminal (or from a PowerShell terminal on Windows):

```sh
cd ei-install-scripts-main
```

## Linux/Ubuntu/Raspbian, etc.

From a command line terminal run:

```sh
. ./install-linux.sh
```

## macOS

From a command line terminal run:

```sh
. ./install-mac.sh
```

## Windows

From a PowerShell terminal run:

```powershell
Start-Process powershell.exe -ArgumentList ("-NoExit",("cd {0}" -f (Get-Location).path)) -Verb RunAs
<# Click Yes, then from the new PowerShell window, run: #>
.\install-windows.ps1
```
