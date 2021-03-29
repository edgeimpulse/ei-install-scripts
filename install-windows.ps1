#Requires -RunAsAdministrator
Param(
    [Parameter(Mandatory=$false)]
    [switch]$updateAll = $false
);

<# Check/install/update Chocolatey #>
$testchoco = &{choco -V} 2>&1
Write-Host "Chocolatey version = $testchoco" -ForegroundColor green
if(-not($testchoco)) {
    $install = Read-Host -Prompt "Install Chocolatey? [yes/no]"
    if($install -like "yes") {
    Write-Host "Installing chocolatey..." -ForegroundColor magenta
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
} 
elseif($updateAll) {
    Write-Host "Updating chocolatey..." -ForegroundColor magenta
    choco upgrade -y chocolatey
}

<# Check for existing Python installations #>
$pythonexists = &{py -0} 2>&1
$pythonversion = &{python -V} 2>&1
$testpython2 = $false
$testpython3 = $false
if(-not($pythonexists -Match "term 'py' is not recognized")) {
    #Write-Host $pythonexists -ForegroundColor yellow
    $testpython2 = &{py -2 -V} 2>&1
    $testpython3 = &{py -3 -V} 2>&1
    if(-not($testpython2 -Match "Python 2")) {
        $testpython2 = $false
    }
    if(-not($testpython3 -Match "Python 3")) {
        $testpython3 = $false
    }
}
else {
    # Only one Python installation can be found
    <#$pythondir = &{python -c "import sys; print(sys.executable)"} 2>&1
    if(-not($pythonversion -Match "Python was not found")) {
        Write-Host "Found $pythonversion in $pythondir" -ForegroundColor yellow
    }#>
    if($pythonversion -Match "Python 2") {
        $testpython2 = $pythonversion
    }
    if($pythonversion -Match "Python 3") {
        $testpython3 = $pythonversion
    }
}

<# Check/install/update Python 2 #>
if($testpython2) {
    Write-Host "Python 2 version = $testpython2" -ForegroundColor green
}
elseif((-not($pythonexists -Match "-2.")) -or (-not($pythonversion -Match "Python 2"))) {
    Write-Host "ERROR: Python 2 cannot be found." -ForegroundColor red
    Write-Host "If Python 2 is already installed, check that it is in your PATH." -ForegroundColor red
    $install = Read-Host -Prompt "Install Python 2 with Chocolatey? [yes/no]"
    if($install -like "yes") {
        Write-Host "Installing Python 2..." -ForegroundColor magenta
        choco install -y python2
    }
}
if($updateAll) {
    Write-Host "Updating Python 2..." -ForegroundColor magenta
    choco upgrade -y python2
}

<# Check/install/update Python 3 #>
if($testpython3) {
    Write-Host "Python 3 version = $testpython3" -ForegroundColor green
}
elseif((-not($pythonexists -Match "-3.")) -or (-not($pythonversion -Match "Python 3"))) {
    Write-Host "ERROR: Python 3 cannot be found." -ForegroundColor red
    Write-Host "If Python 3 is already installed, check that it is in your PATH." -ForegroundColor red
    $install = Read-Host -Prompt "Install Python 3 with Chocolatey? [yes/no]"
    if($install -like "yes") {
        Write-Host "Installing Python 3..." -ForegroundColor magenta
        choco install -y python3
    }
}
if($updateAll) {
    Write-Host "Updating Python 3..." -ForegroundColor magenta
    choco upgrade -y python3
}

<# Check/install/update Node & npm #>
$testnode = &{node -v} 2>&1
$testnpm = &{npm -v} 2>&1
if(-not($testnode -Match "The term 'node' is not recognized")) {
    Write-Host "Node.js version = $testnode" -ForegroundColor green
    if(-not($testnpm -Match "The term 'npm' is not recognized")) {
        Write-Host "npm version = $testnpm" -ForegroundColor green
    }
}
else {
    Write-Host "ERROR: Node.js cannot be found." -ForegroundColor red
    Write-Host "If Node.js is already installed, check that it is in your PATH." -ForegroundColor red
    $install = Read-Host -Prompt "Install Node.js & npm with Chocolatey? [yes/no]"
    if($install -like "yes") {
        Write-Host "Installing Node.js & npm..." -ForegroundColor magenta
        cinst -y nodejs.install
    }
}
if($updateAll) {
    Write-Host "Updating Node.js & npm..." -ForegroundColor magenta
    choco upgrade -y nodejs.install
}

<# Check/install/update edge-impulse-cli #>
$testei = &{npm list --depth 1 --global edge-impulse-cli} 2>&1
if($testei -Match "edge-impulse-cli") {
    #$testei = $testei -replace "^.*?`-"
    Write-Host "edge-impulse-cli version = $testei" -ForegroundColor green
}
elseif($testei -Match "The term 'npm' is not recognized") {
    Write-Host "ERROR: Re-run this script and install Node.js & npm." -ForegroundColor red
}
else {
    Write-Host "ERROR: edge-impulse-cli cannot be found." -ForegroundColor red
    $install = Read-Host -Prompt "Install edge-impulse-cli? [yes/no]"
    if($install -like "yes") {
        Write-Host "Installing edge-impulse-cli..." -ForegroundColor magenta
        npm install -g edge-impulse-cli
    }
}
if($updateAll) {
    Write-Host "Updating edge-impulse-cli..." -ForegroundColor magenta
    npm update -g edge-impulse-cli
}

<# Prompt refresh environment variables for new Python installations #>
if ($install -like "yes") {
    Write-Host "Run 'refreshenv' and close/reopen a new administrator PowerShell terminal to see installation changes." -ForegroundColor red -BackgroundColor black
}