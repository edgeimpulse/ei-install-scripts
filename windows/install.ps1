#Requires -RunAsAdministrator

function Refresh-Environment {
    # Reload the session so that we can find new installs
    refreshenv
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
}

function Mark-Success {
	[CmdletBinding()]
	param(
		[Parameter()]
		[string] $Message
	)
	Write-Host "[^_^] " -NoNewLine -ForegroundColor green
	Write-Host "$Message" -ForegroundColor green
}

function Mark-Warning {
	[CmdletBinding()]
	param(
		[Parameter()]
		[string] $Message
	)
	Write-Host "[>_<] " -NoNewLine -ForegroundColor red
	Write-Host "$Message" -ForegroundColor red
}

function Mark-Error {
	[CmdletBinding()]
	param(
		[Parameter()]
		[string] $Message
	)
    Write-Host ""
	Mark-Warning -Message $Message
    Write-Host ""
    Exit 1
}

function Install-Node {
    $appstring = "Node.js v14"
    Write-Host ""
    Mark-Warning -Message "$appstring cannot be found."
    Write-Host "      If $appstring is already installed, check that it is in your PATH." -ForegroundColor red
    Write-Host ""
    $install = Read-Host -Prompt "Do you want to install $appstring ($Arch) from https://nodejs.org? [yes/no]"
    if ($install -like "yes") {
        Write-Host ""
        Write-Host "Installing $appstring ($Arch), this may take a while..." -ForegroundColor magenta
        Write-Host ""
        if ($Arch -eq 'x86') {
            Invoke-WebRequest -Uri "https://nodejs.org/dist/v14.18.1/node-v14.18.1-x86.msi" -Outfile nodev14.msi
        }
        elseif ($Arch -eq 'amd64') {
            Invoke-WebRequest -Uri "https://nodejs.org/dist/v14.18.1/node-v14.18.1-x64.msi" -Outfile nodev14.msi
        }

        # Install from downloaded installer
        start -wait .\nodev14.msi /qn
        del .\nodev14.msi   # Delete installer
        Refresh-Environment
    }
    else {
        Mark-Error -Message "Cancelled. Please install $appstring and run this command again."
    }
}

function Install-Python {
    $appstring = "Python 3"
    Write-Host ""
    Mark-Warning -Message "$appstring cannot be found."
    Write-Host "      If $appstring is already installed, check that it is in your PATH." -ForegroundColor red
    Write-Host ""
    $install = Read-Host -Prompt "Do you want to install $appstring ($Arch) from https://python.org? [yes/no]"
    if ($install -like "yes") {
        Write-Host ""
        Write-Host "Installing $appstring ($Arch), this may take a while..." -ForegroundColor magenta
        Write-Host ""
        if ($Arch -eq 'x86') {
            Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.8/python-3.9.8.exe" -Outfile python3.exe
        }
        elseif ($Arch -eq 'amd64') {
            Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.8/python-3.9.8-amd64.exe" -Outfile python3.exe
        }

        # Install from downloaded installer
        start -wait .\python3.exe -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1"
        del .\python3.exe   # Delete installer
        Refresh-Environment
    }
    else {
        Mark-Error -Message "Cancelled. Please install $appstring and run this command again."
    }
}

function Check-Node {
    Write-Host "Checking if you have Node.js v14 installed..."
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
    Mark-Success -Message "$result installed"
}

function Check-Python {
    Write-Host "Checking if you have Python 3 installed..."
    Try{
        $pythonversion = & {python --version}
        if (!($pythonversion -like "*Python 3.*")) {
            Install-Python
        }
    }
    Catch{
        Install-Python
    }

    $result = Invoke-Expression "python --version"
    Mark-Success -Message "$result installed"
}

function Check-BuildTools{
    Write-Host ""
    Write-Host "The Edge Impulse CLI requires some ot the build tools for C++ to be" -ForegroundColor magenta
    Write-Host "installed in your computer. If you have a fully functional Visual Studio" -ForegroundColor magenta
    Write-Host "environment for C++ development, or if you prefer to check, troubleshoot" -ForegroundColor magenta
    Write-Host "and install the tools manually, you may skip this check. Otherwise, we" -ForegroundColor magenta
    Write-Host "will use the build tools installer for Visual Studio 2019 to check and" -ForegroundColor magenta
    Write-Host "install all the required tools. The installation needs up to 5GB of free" -ForegroundColor magenta
    Write-Host "space and may take several minutes to complete." -ForegroundColor magenta
    $install = Read-Host -Prompt "Do you want to continue checking the build tools for C++? [yes/no]"
    if ($install -like "yes") {
        Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vs_buildtools.exe" -Outfile vs_buildtools.exe

        # Install from downloaded installer
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

Write-Host ""
Refresh-Environment
# Check if running in admin shell
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Mark-Error -Message "This script must be run from an Administrator session. Please open a new session using 'Run as Administrator' and try again."
}
$Arch = (Get-Process -Id $PID).StartInfo.EnvironmentVariables["PROCESSOR_ARCHITECTURE"];
Check-BuildTools
Check-Python
Check-Node
Try{
    $result = & {npm install -g edge-impulse-cli}
}
Catch{
    Mark-Error -Message "Could not install Edge Impulse CLI. Please correct the errors and try again."
}

Mark-Success -Message "Edge Impulse CLI installed successfully. Please restart your computer before using it!"
