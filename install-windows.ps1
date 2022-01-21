#Requires -RunAsAdministrator

$CLI_STRING = "Edge Impulse CLI"
$BUILD_TOOLS_STRING = "Build Tools for Windows"
$PY_REQ_STR = "Python 3.7 or higher"
$PY_INSTALL_STR = "Python 3.9"
$NODE_REQ_STR = "Node.js v12 or higher"
$NODE_INSTALL_STR = "Node.js v14"
$Arch = ('x86', 'amd64')[[bool] ${env:ProgramFiles(x86)}]
# $Arch = (Get-Process -Id $PID).StartInfo.EnvironmentVariables["PROCESSOR_ARCHITECTURE"];

function Refresh-Environment {
    # Reload the session so that we can find new installs
    # refreshenv
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

function Write-Success([String]$Message) {
	Write-Host "[^_^] " -NoNewLine -ForegroundColor green
	Write-Host "$Message" -ForegroundColor green
}

function Write-Warning([String]$Message) {
	Write-Host "[>_<] " -NoNewLine -ForegroundColor yellow
	Write-Host "$Message" -ForegroundColor yellow
}

function Write-Error([String]$Message) {
    Write-Host ""
	Write-Warning $Message
    Write-Host ""
    Exit 1
}

function Install-Node {
    Try{
        Write-Host ""
        Write-Warning "Could not find $NODE_REQ_STR."
        Write-Host "      If $NODE_REQ_STR is already installed, check that it is in your PATH." -ForegroundColor yellow
        $install = $(Write-Host "      Do you want to install $NODE_INSTALL_STR ($Arch) from nodejs.org? [y/N] " -ForegroundColor magenta -NoNewLine; Read-Host)
        if (($install -like "y") -or ($install -like "Y")) {
            Write-Host "Downloading the $NODE_INSTALL_STR ($Arch) installer, this may take a few minutes..."
            if ($Arch -eq 'x86') {
                Invoke-WebRequest -Uri "https://nodejs.org/dist/v14.18.1/node-v14.18.1-x86.msi" -Outfile nodev14.msi
            }
            elseif ($Arch -eq 'amd64') {
                Invoke-WebRequest -Uri "https://nodejs.org/dist/v14.18.1/node-v14.18.1-x64.msi" -Outfile nodev14.msi
            }
            Write-Host "Installing $NODE_INSTALL_STR ($Arch), this may take a few minutes..."
            start -wait .\nodev14.msi /qn
            del .\nodev14.msi   # Delete installer
            Refresh-Environment
        }
        else {
            Write-Error "Cancelled. Please install $NODE_REQ_STR and run this command again."
        }
    }
    Catch{
        Write-Error "$NODE_INSTALL_STR installation terminated unexpectedly. Please try again."
    }
}

function Install-Python {
    Try{
        Write-Host ""
        Write-Warning "Could not find $PY_REQ_STR."
        Write-Host "      If $PY_REQ_STR is already installed, check that it is in your PATH." -ForegroundColor yellow
        $install = $(Write-Host "      Do you want to install $PY_INSTALL_STR ($Arch) from python.org? [y/N] " -ForegroundColor magenta -NoNewLine; Read-Host)
        if (($install -like "y") -or ($install -like "Y")) {
            Write-Host "Downloading the $PY_INSTALL_STR ($Arch) installer, this may take a few minutes..."
            if ($Arch -eq 'x86') {
                Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.8/python-3.9.8.exe" -Outfile python3.exe
            }
            elseif ($Arch -eq 'amd64') {
                Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.8/python-3.9.8-amd64.exe" -Outfile python3.exe
            }
            Write-Host "Installing $PY_INSTALL_STR ($Arch), this may take a few minutes while..."
            start -wait .\python3.exe -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1"
            del .\python3.exe   # Delete installer
            Refresh-Environment
        }
        else {
            Write-Error "Cancelled. Please install $PY_REQ_STR and run this command again."
        }
    }
    Catch{
        Write-Error "$PY_INSTALL_STR installation terminated unexpectedly. Please try again."
    }
}

function Install-BuildTools {
    Try{
        Write-Host "Downloading the $BUILD_TOOLS_STRING bootstrapper, this may take a few minutes..."
        Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vs_buildtools.exe" -Outfile vs_buildtools.exe
        Write-Host "Checking your $BUILD_TOOLS_STRING configuration. This may take several minutes..."
        start -wait .\vs_buildtools.exe -ArgumentList "--quiet --wait --norestart ^
        #                                              --add Microsoft.VisualStudio.Component.Windows10SDK.19041 ^
                                                        --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64"
        # start -wait .\vs_buildtools.exe -ArgumentList "--quiet --wait --norestart ^
        #                                             --add Microsoft.VisualStudio.Component.VC.CMake.Project ^
        #                                             --add Microsoft.VisualStudio.Component.Windows10SDK ^
        del .\vs_buildtools.exe   # Delete installer
        Refresh-Environment
    }
    Catch{
        Write-Error "$BUILD_TOOLS_STR installation terminated unexpectedly. Please try again."
    }
}

function Check-Node {
    Write-Host "Checking if you have $NODE_REQ_STR installed..."
    Try{
        $nodeversion = & {node --version}
        $nodeversion = $nodeversion -replace 'v',''
        if ([System.Version]$nodeversion -lt  [System.Version]"12.0.0") {
            Install-Node
        }
    }
    Catch{
        # Command doesn't exist, install it!
        Install-Node
    }

    $result = Invoke-Expression "node --version"
    Write-Success "Node.js $result installed!"
}

function Check-Python {
    Write-Host "Checking if you have $PY_REQ_STR installed..."
    Try{
        $pyversion = & {python --version}
        $pyversion = $pyversion -replace 'Python ',''
        $pyversion = $pyversion -replace 'python ',''
        if ($pyversion -like "2.*") {
            if (([System.Version]$pyversion -lt  [System.Version]"2.7.0")) {
                Install-Python
            }
        }
        if ($pyversion -like "3.*") {
            if (([System.Version]$pyversion -lt  [System.Version]"3.7.0")) {
                Install-Python
            }
        }
        else {
            Install-Python
        }
    }
    Catch{
        Install-Python
    }

    $result = Invoke-Expression "python --version"
    Write-Success "$result installed!"
}

function Install-CLI {
    Try{
        Write-Host "Installing the $CLI_STRING..."
        Write-Host "npm install -g edge-impulse-cli"
        npm install -g edge-impulse-cli
        Refresh-Environment
        Check-CLI
    }
    Catch{
        Write-Error "Failed to install $CLI_STRING. Please report the issue."
    }
}

function Check-CLI{
    Try{
        $eicliversion = & {edge-impulse-blocks -V}
        if ($eicliversion -like "1.*") {
            Write-Success "$CLI_STRING $eicliversion installed!"
            Exit
        }
    }
    Catch{
    }
    Write-Warning "$CLI_STRING is not installed."
}

Refresh-Environment
Write-Success "Refreshed Environment"
# Check if running in admin shell
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Error "This script must be run from an Administrator session. Please open a new session using 'Run as Administrator' and try again."
}
Write-Success "Running as admin on $Arch"
Check-CLI
Check-Node
Check-Python
Install-BuildTools
Install-CLI
