#PowerShell Lunch & Learn - Core - Day 1: Console, Finding Commands, Filtering Results

#Show me the commands
Get-Command

#How do I use this command? Notice some parameters are not available when others are used.
Help Get-Process
Help Get-Service

#Questions about Help?


Get-Service | Select-Object *

#Using Select-Object we can also grab a single service from the collection.
Get-Service | Select-Object * -First 1

#The previous command gave us too much info.
Get-Service | Select-Object Name,StartType,Status

#Questions about Select-Object?




#Pipeline Explanation

#How do I filter down to services that are supposed to be running?
Get-Service | Where-Object {$_.StartType -like "Automatic"} | Select-Object DisplayName,StartType,Status

#How do I sort these object by their Status?
Get-Service | Where-Object {$_.StartType -like "Automatic"} | Select-Object Name,StartType,Status | Sort-Object -Property Status
#Always be sure to use Sort-Object after Where-Object and Select-Object in the same command for time savings.

#Questions about Where-Object or Pipeline?




#The following command will list all modules currently installed on the system. Notice the different folder paths.
Get-Module -ListAvailable

#Modules can be downloaded from the internet and installed or placed in some of the module paths listed earlier.
#PowerShell 5.0 comes with the ability to search and download directly from a Microsoft's PowerShell Gallery
Find-Module -Name *vmware*

$GalleryModules = Find-Module

$GalleryModules | select Name,Author

Install-Module -Name PSDocs

Get-Command -Module PSDocs

Uninstall-Module -Name PSDocs -Force





####### IGNORE BELOW UNLESS THERE IS TIME LEFT ########

#Importing the ActiveDirectory module below so we can work with user objects.
#If on Windows Client OS, must install RSAT version appropriate for your OS first.
Import-Module ActiveDirectory

Help Get-ADUser

Get-ADUser jmilczek

Get-ADUser jmilczek -Properties *

Get-ADUser -filter "givenname -like 'John'"

Get-ADUser -filter "givenname -like 'John'" -Properties *



