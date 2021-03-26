#Requires -RunAsAdministrator
$testchoco = powershell choco -v
if(-not($testchoco)) {
    echo "Installing chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
else {
    echo "Updating chocolatey..."
    choco upgrade -y chocolatey
}
$testpython = powershell python --version
if(-not($testpython)) {
    echo "Installing Python..."
    choco install -y python
}
else {
    echo "Updating Python..."
    choco upgrade -y python
}
$testnode = powershell node -v
if(-not($testnode)) {
    echo "Installing Node.js & npm..."
    cinst -y nodejs.install
}
else {
    echo "Updating Node.js & npm..."
    choco upgrade -y nodejs.install
}
$testei = powershell npm info edge-impulse-cli version
if(-not($testei)) {
    echo "Installing edge-impulse-cli..."
    npm install -g edge-impulse-cli
}
else {
    echo "Updating edge-impulse-cli..."
    npm update -g edge-impulse-cli
}