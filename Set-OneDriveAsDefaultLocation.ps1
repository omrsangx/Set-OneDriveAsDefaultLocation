<#

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

Author:  Omar Rosa

#>

# Verify that there is an account already setup in OneDrive:
$oneDriveAccount = Get-ChildItem -path HKCU:\Software\Microsoft\OneDrive\Accounts\
$userEmailValue = $oneDriveAccount.Property -match 'UserEmail'

IF ($userEmailValue -eq 'UserEmail')
{
$PathWin10FolderOnC = 'C:\OneDriveBackUpFiles'

# Naming both reg files with the Get-Date cmdlet:
$dateOnDate = Get-Date 
$fileNameDateHKCUShell = "HKCU-ShellFolder " + ($dateOnDate.hour -as [string]) + "-" + ($dateOnDate.minute -as [string]) + "_" + ($dateOnDate.month -as [string]) + "_" + ($dateOnDate.day -as [string]) + "_" + ($dateOnDate.year -as [string])
$fileNameDateHKCUUserShell = "HKCU-UserShellFolder " + ($dateOnDate.hour -as [string]) + "-" + ($dateOnDate.minute -as [string]) + "_" + ($dateOnDate.month -as [string]) + "_" + ($dateOnDate.day -as [string]) + "_" + ($dateOnDate.year -as [string])


# Checking whether c:\OneDriveBackUpFiles exists; if not, it will be created, and then the backup Reg files will be placed there:
IF(!(Test-Path $PathWin10FolderOnC))
{
    New-Item -Path $PathWin10FolderOnC -Type Directory
    Reg export 'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' C:\OneDriveBackUpFiles\$fileNameDateHKCUShell.reg
    Reg export 'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' C:\OneDriveBackUpFiles\$fileNameDateHKCUUserShell.reg
}

ELSE
{
    Reg export 'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' C:\OneDriveBackUpFiles\$fileNameDateHKCUShell.reg
    Reg export 'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' C:\OneDriveBackUpFiles\$fileNameDateHKCUUserShell.reg
}


#------ for Shell Folders\Personal: 
$registryPathShellFolders1 = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'
$RegistryName = 'Personal'
$registryValue = '%USERPROFILE%\OneDrive'
$registryPropertyType1 = 'String'


# Checking whether HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders key exists; if not, it will be created, and then modify with our desired value:
IF(!(Test-Path $registryPathShellFolders))
{
    New-Item -Path $registryPathShellFolders1 -Force | Out-Null
    
    New-ItemProperty -Path $registryPathShellFolders1 -Name $RegistryName -Value $registryValue -PropertyType $registryPropertyType1 -Force | Out-Null
}

ELSE 
{ 
    New-ItemProperty -Path $registryPathShellFolders1 -Name $RegistryName -Value $registryValue -PropertyType $registryPropertyType1 -Force | Out-Null
}


#------ for User Shell Folders\Personal:
$registryPathUserShellFolders2 = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
$RegistryName = 'Personal'
$registryValue = '%USERPROFILE%\OneDrive'
$registryPropertyType2 = 'ExpandString'


# Checking whether HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders key exists; if not, it will be created, and then modify with our desired value:
IF(!(Test-Path $registryPathUserShellFolders))
{
    New-Item -Path $registryPathUserShellFolders2 -Force | Out-Null
    
    New-ItemProperty -Path $registryPathUserShellFolders2 -Name $RegistryName -Value $registryValue -PropertyType $registryPropertyType2 -Force | Out-Null
}

ELSE 
{ 
    New-ItemProperty -Path $registryPathUserShellFolders2 -Name $RegistryName -Value $registryValue -PropertyType $registryPropertyType2 -Force | Out-Null

}
    

} # END OF IF

# If OneDrive/OneDrive for business is not setup, launch OneDrive for the user to sign in:

ELSE 
{

    Write-Host "OneDrive needs to be setup and then run the script again"

    # Change <username> with correct username
    c:\users\<username>\AppData\Local\Microsoft\OneDrive\OneDrive.exe

} # END OF ELSE

