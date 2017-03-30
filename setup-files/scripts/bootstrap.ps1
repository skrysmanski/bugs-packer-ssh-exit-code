# Bootstrap script
$script:ErrorActionPreference = 'Stop'

#
# Disable services that cause the public/private network detection.
# See: http://serverfault.com/a/634983/71268
#

# Network List Service
Stop-Service netprofm
Set-Service netprofm -StartupType Disabled

#
# Enable Remote Desktop
#
. .\Enable-RemoteDesktop.ps1
Enable-RemoteDesktop
netsh advfirewall firewall add rule name="Remote Desktop" dir=in localport=3389 protocol=TCP action=allow

#
# Install chocolatey packer manager
#
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

#
# Install OpenSSH server
#
choco install -y mls-software-openssh

#
# Disable page file (to have a smaller base image)
#
Write-Host "Removing page file"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "PagingFiles" -Value ""

#
# Make "postunattend.xml" available to shutdown process (see packer json file).
#
copy-item a:\postunattend.xml C:\postunattend.xml
