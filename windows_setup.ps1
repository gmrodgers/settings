Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install googlechrome --yes
choco install firefox --yes
choco install cmder --yes
choco install git --yes
choco install ccleaner --yes
choco install vscode --yes
choco install libreoffice-fresh --yes
choco install zoom --yes
choco install adobereader --yes
choco install qbittorrent --yes
choco install vlc --yes
choco install vagrant --yes
choco install virtualbox --yes
choco install tor-browser --yes
choco install caffeine --yes
# choco install spotify --yes

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
# choco install wsl --yes
# choco install wsl-ubuntu-1804 --yes
