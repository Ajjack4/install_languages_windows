# PowerShell Script for Installing Programming Languages on Windows

# Function to download and run installer
function Install-From-URL {
    param (
        [string]$url,
        [string]$installerName
    )
    Write-Host "Downloading $installerName..."
    $output = "$env:TEMP\$installerName"
    Start-BitsTransfer -Source $url -Destination $output
    Write-Host "Running $installerName..."
    Start-Process -FilePath $output -Wait -NoNewWindow
    Remove-Item -Path $output -Force
}

# Function to add a path to the system environment variables
function Add-To-SystemPath {
    param (
        [string]$newPath
    )
    $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    if (-not $currentPath.Contains($newPath)) {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$newPath", [EnvironmentVariableTarget]::Machine)
        Write-Host "$newPath added to system PATH."
    } else {
        Write-Host "$newPath is already in the system PATH."
    }
}

# Install MinGW (C and C++)
Write-Host "Installing MinGW for C and C++..."
Install-From-URL -url "https://github.com/niXman/mingw-builds-binaries/releases/download/14.2.0-rt_v12-rev0/x86_64-14.2.0-release-posix-seh-msvcrt-rt_v12-rev0.7z" -installerName "mingw.exe"
Add-To-SystemPath -newPath "C:\\MinGW\\bin"
Write-Host "Verifying installation..."
gcc --version
g++ --version

# Install Python
Write-Host "Installing Python..."
Install-From-URL -url "https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe" -installerName "python-installer.exe"
Write-Host "Verifying installation..."
python --version

# Install Node.js (JavaScript)
Write-Host "Installing Node.js..."
Install-From-URL -url "https://nodejs.org/dist/v18.18.2/node-v18.18.2-x64.msi" -installerName "nodejs.msi"
Write-Host "Verifying installation..."
node --version
npm --version

# Install PHP
Write-Host "Installing PHP..."
Install-From-URL -url "https://windows.php.net/downloads/releases/php-8.2.0-Win32-vs16-x64.zip" -installerName "php.zip"
Expand-Archive "$env:TEMP\php.zip" -DestinationPath "C:\\PHP" -Force
Add-To-SystemPath -newPath "C:\\PHP"
Write-Host "Verifying installation..."
php --version

# Install Java
Write-Host "Installing Java..."
Install-From-URL -url "https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe" -installerName "jdk-installer.exe"
$jdkPath = "C:\\Program Files\\Java\\jdk-17"
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, [EnvironmentVariableTarget]::Machine)
Add-To-SystemPath -newPath "$jdkPath\\bin"
Write-Host "Verifying installation..."
java -version

# Install TypeScript
Write-Host "Installing TypeScript..."
npm install -g typescript
Write-Host "Verifying installation..."
tsc --version

Write-Host "All installations completed successfully!"
