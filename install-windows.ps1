#Requires -RunAsAdministrator
$testchoco = powershell choco -v
if(-not($testchoco)) {
    echo "Installing chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
else {
    echo "Updating chocolatey..."
    choco upgrade chocolatey
}
$testpython = powershell python --version
if(-not($testpython)) {
    echo "Installing Python..."
    choco install python
}
else {
    echo "Updating Python..."
    choco upgrade python
}
$testnode = powershell node -v
if(-not($testnode)) {
    echo "Installing Node.js & npm..."
    cinst nodejs.install
}
else {
    echo "Updating Node.js & npm..."
    choco upgrade nodejs.install
}
$testnode = powershell node -v
if(-not($testnode)) {
    echo "Installing Node.js & npm..."
    cinst nodejs.install
}
else {
    echo "Updating Node.js & npm..."
    choco upgrade nodejs.install
}