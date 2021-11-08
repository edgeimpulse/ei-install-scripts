#Requires -RunAsAdministrator

$pythonstring = "Python 3"
$nodestring = "Node.js v14"
$Arch = (Get-Process -Id $PID).StartInfo.EnvironmentVariables["PROCESSOR_ARCHITECTURE"];

function Refresh-Environment {
    # Reload the session so that we can find new installs
    refreshenv
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
}

function Write-Success {
	[CmdletBinding()]
	param(
		[Parameter()]
		[string] $Message
	)
	Write-Host "[^_^] " -NoNewLine -ForegroundColor green
	Write-Host "$Message" -ForegroundColor green
}

function Write-Warning {
	[CmdletBinding()]
	param(
		[Parameter()]
		[string] $Message
	)
	Write-Host "[>_<] " -NoNewLine -ForegroundColor yellow
	Write-Host "$Message" -ForegroundColor yellow
}

function Write-Error {
	[CmdletBinding()]
	param(
		[Parameter()]
		[string] $Message
	)
    Write-Host ""
	Write-Warning -Message $Message
    Write-Host ""
    Exit 1
}

function Install-Node {
    Write-Host ""
    Write-Warning -Message "$nodestring cannot be found."
    Write-Host "      If $nodestring is already installed, check that it is in your PATH." -ForegroundColor red
    $install = $(Write-Host ""; Write-Host "Do you want to install $nodestring ($Arch) from https://nodejs.org? [yes/no] " -ForegroundColor magenta -NoNewLine; Read-Host)
    if ($install -like "yes") {
        Write-Host "Downloading the $nodestring ($Arch) installer..."
        if ($Arch -eq 'x86') {
            Invoke-WebRequest -Uri "https://nodejs.org/dist/v14.18.1/node-v14.18.1-x86.msi" -Outfile nodev14.msi
        }
        elseif ($Arch -eq 'amd64') {
            Invoke-WebRequest -Uri "https://nodejs.org/dist/v14.18.1/node-v14.18.1-x64.msi" -Outfile nodev14.msi
        }
        Write-Host "Installing $nodestring ($Arch), this may take a while..."
        start -wait .\nodev14.msi /qn
        del .\nodev14.msi   # Delete installer
        Refresh-Environment
    }
    else {
        Write-Error -Message "Cancelled. Please install $nodestring and run this command again."
    }
}

function Install-Python {
    Write-Host ""
    Write-Warning -Message "$pythonstring cannot be found."
    Write-Host "      If $pythonstring is already installed, check that it is in your PATH." -ForegroundColor red
    $install = $(Write-Host ""; Write-Host "Do you want to install $pythonstring ($Arch) from https://python.org? [yes/no] " -ForegroundColor magenta -NoNewLine; Read-Host)
    if ($install -like "yes") {
        Write-Host "Downloading the $pythonstring ($Arch) installer..."
        if ($Arch -eq 'x86') {
            Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.8/python-3.9.8.exe" -Outfile python3.exe
        }
        elseif ($Arch -eq 'amd64') {
            Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.8/python-3.9.8-amd64.exe" -Outfile python3.exe
        }
        Write-Host "Installing $pythonstring ($Arch), this may take a while..."
        start -wait .\python3.exe -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1"
        del .\python3.exe   # Delete installer
        Refresh-Environment
    }
    else {
        Write-Error -Message "Cancelled. Please install $pythonstring and run this command again."
    }
}

function Check-Node {
    Write-Host "Checking if you have $nodestring installed..."
    Try{
        $nodeversion = & {node --version}
        if (!($nodeversion -like "*v14*")) {
            Install-Node
        }
    }
    Catch{
        # Command doesn't exist, install it!
        Install-Node
    }

    $result = Invoke-Expression "node --version"
    Write-Success -Message "$result installed"
}

function Check-Python {
    Write-Host "Checking if you have $pythonstring installed..."
    Try{
        $pythonversion = & {python --version}
        if (!($pythonversion -like "*$pythonstring.*")) {
            Install-Python
        }
    }
    Catch{
        Install-Python
    }

    $result = Invoke-Expression "python --version"
    Write-Success -Message "$result installed"
}

function Check-BuildTools{
    Write-Host ""
    Write-Host "The Edge Impulse CLI requires some of the build tools for C++ to be"
    Write-Host "installed in your computer. If you already have a functional environment"
    Write-Host "for C++ development, or if you prefer to check, troubleshoot and install"
    Write-Host "the tools manually, you may skip this check. Otherwise, we will download"
    Write-Host "and execute the build tools bootstrap installer for Visual Studio 2019"
    Write-Host "to check and install the required tools. The installation needs up to 5GB"
    Write-Host "of free space and may take several minutes to complete."
    $install = $(Write-Host ""; Write-Host "Do you want this script to check for, and install, the required build tools? [yes/skip] " -ForegroundColor magenta -NoNewLine; Read-Host)
    if ($install -like "yes") {
        Write-Host "Downloading the Visual Studio 2019 build tools installer..."
        Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vs_buildtools.exe" -Outfile vs_buildtools.exe
        Write-Host "Checking build tools for missing components. This may take several minutes..."
        start -wait .\vs_buildtools.exe -ArgumentList "--quiet --wait --norestart ^
                                                    --add Microsoft.VisualStudio.Workload.VCTools ^
                                                    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
                                                    --add Microsoft.VisualStudio.Component.VC.CMake.Project ^
                                                    --add Microsoft.VisualStudio.Component.Windows10SDK ^
                                                    --add Microsoft.VisualStudio.Component.Windows10SDK.19041"
        del .\vs_buildtools.exe   # Delete installer
        Refresh-Environment
    }
}

Refresh-Environment
# Check if running in admin shell
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error -Message "This script must be run from an Administrator session. Please open a new session using 'Run as Administrator' and try again."
}
Check-BuildTools
Check-Python
Check-Node
Try{
    $result = & {npm install -g edge-impulse-cli}
}
Catch{
    Write-Error -Message "Could not install Edge Impulse CLI. Please correct the errors and try again."
}
Write-Success -Message "Edge Impulse CLI installed successfully!"
Write-Host "      PLEASE REBOOT YOUR COMPUTER BEFORE USING IT!"