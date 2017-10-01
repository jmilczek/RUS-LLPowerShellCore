#requires -RunAsAdministrator

Set-Location C:\PowerShell\Repo\RUS-LLPowerShellCore

Get-ChildItem *.ps1 | foreach {

    $psISE.CurrentPowerShellTab.Files.Add($_.FullName)

}

$Host.PrivateData.Zoom = 145