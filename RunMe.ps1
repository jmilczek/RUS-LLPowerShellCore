#Requires -Modules ActiveDirectory
#Requires -Version 5.0

param (

    [Parameter(Mandatory=$true,Position=0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,
    [Parameter(Mandatory=$true,Position=1)]
    [ValidateSet("RUS", "RLA", "RCI", "REI")]
    $Company,
    $Location = "Atlanta",
    $LogFilePath = (".\RunMe" + (get-date -Format yyyyMMdd) + ".log"),
    [Switch]$kellermeyer

)

function Write-Error {

    param($message)
    Write-EventLog -LogName Application -Source "My Script" -EntryType Error -Message $message -EventId 9999
    Write-Output "`nGet-ADUser failed with error: $message." | Out-File -FilePath $LogFilePath -Append
    if ($kellermeyer) {Send-MailMessage -From "sender@mail.com" -To "recipient@mail.com","recipient2@mail.com" -Body $message -SmtpServer "smtp.mail.com"}

}

#Output

Write-Output "Hello $Name of $Company from $Location!"

If ($kellermeyer) {

    Write-Host "There are three flowers in a vase, the third flower is " -ForegroundColor Magenta -NoNewline
    Write-Host "green" -ForegroundColor Green -NoNewline
    Write-Host "." -ForegroundColor Magenta
}

New-EventLog -LogName Application -Source "My Script" -ErrorAction SilentlyContinue
$ErrorActionPreference = "Stop"
try {

    Get-ADUser jmilczek12345

}
catch {

    Write-Error $_.Exception.Message

}