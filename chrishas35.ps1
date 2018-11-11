Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
# executeScript "FileExplorerSettings.ps1";
# Show hidden files, Show protected OS files, Show file extensions
# Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
Set-WindowsExplorerOptions -EnableShowFileExtensions
# will expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1

# executeScript "SystemConfiguration.ps1";
#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

# executeScript "CommonDevTools.ps1";
# tools we expect devs across many scenarios will want
choco install -y vscode
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y python
choco install -y 7zip.install
# choco install -y sysinternals

executeScript "RemoveDefaultApps.ps1";
# executeScript "HyperV.ps1";
# executeScript "Docker.ps1";
# executeScript "WSL.ps1";
# executeScript "Browsers.ps1";

#--- Tools ---
# code --install-extension msjsdiag.debugger-for-chrome
# code --install-extension msjsdiag.debugger-for-edge

#--- Microsoft WebDriver ---
# choco install -y microsoftwebdriver

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
