# Edge Impulse CLI Install Scripts

Install [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for your OS, then follow the steps below.

## Linux/Ubuntu/Raspbian, etc.

From a command line terminal run:

```sh
git clone https://github.com/edgeimpulse/ei-install-scripts.git
cd ei-install-scripts
. ./install-linux.sh
```

## macOS

From a command line terminal run:

```sh
git clone https://github.com/edgeimpulse/ei-install-scripts.git
cd ei-install-scripts
. ./install-mac.sh
```

## Windows

From a PowerShell terminal run:

```powershell
git clone https://github.com/edgeimpulse/ei-install-scripts.git
cd ei-install-scripts
Start-Process powershell.exe -ArgumentList ("-NoExit",("cd {0}" -f (Get-Location).path)) -Verb RunAs
<# Click Yes, then from the new PowerShell window, run: #>
.\install-windows.ps1
```
