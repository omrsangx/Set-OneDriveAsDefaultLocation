Set-OneDriveAsDefaultLocation

.SYNOPSIS
Changing Windows Explorer's default location to save files.

.DESCRIPTION
The following script will change the default location to save fiels to OneDrive or OneDrive for Business if user has signed into OneDrive.

.EXAMPLE
The following line create a registry key, 'Personal', under HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders with value '%USERPROFILE%\OneDrive' and property type 'String':
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders -Name  'Personal' -Value '%USERPROFILE%\OneDrive' -PropertyType 'String' -Force | Out-Null

.NOTES
Warning: Any change undesired change to the registry can have unintended consequence. For example, you can crash the OS. Make a back up of all your data before working with the registry.
Also, instead of running the script one more time after signing into OneDrive, you put the code for the user to sign into OneDrive inside a loop. Once the loop completes, then the rest of the script can run.
This script was tested in Windows 10 which already comes with the OneDrive software already installed.
