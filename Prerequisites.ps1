#requires -RunAsAdministrator
#Run the following commands once per computer. You must "Run as Administrator" when launching PowerShell for them to succeed.

#This will allow you to run local unsigned scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#This will download the most current version of help for all the commands included with the current version of PowerShell
Update-Help
