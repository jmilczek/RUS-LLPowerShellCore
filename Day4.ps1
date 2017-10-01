#PowerShell Lunch & Learn – Day 4: Functions, Parameter Validation, Error Handling

#When creating a script that will be run by others, you'll want to account for as many situations as possible.

################ Script Run Validation ################


#Is your script using abilities only available in a certain version of PowerShell?
#Does your script use commands that require a certain module be installed?
#The "#Requires" feature will address both of the concerns above. This is done by inserting the following line at the beginning of your script:
#Requires -Modules ActiveDirectory
#Requires -Version 5.0


################ Parameter Validation ################

#You can validate the input in many ways: "If" statement, "Switch" statement and some through the actual parameter block.

#Here is the parameter block from Day 2. Notice we've added a few bits.
#In the first parameter $Name, we've made the parameter positional (first) and mandatory.
#We're also validating that the $Name variable's contents are not null ($Null) or empty ("").
#Finally we're casting this variable to a string in case someone entered a name that happened to be numeric (you never know).
#We apply the same behavior to the second parameter $Company and are validating the input by providing a restricted set of answers.
#Location is optional with a default value assigned in case it is ignored.
#Finally, the switch. Unlike the switch statement used in Day 2, this switch is more like a light switch (on/off)...$true/$false.
param (

    [Parameter(Mandatory=$true,Position=0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,
    [Parameter(Mandatory=$true,Position=1)]
    [ValidateSet("RUS", "RLA", "RCI", "REI")]
    $Company,
    $Location = "Atlanta",
    [Switch]$kellermeyer

)
#Output

Write-Output "Hello $Name of $Company from $Location!"

If ($kellermeyer) {

    Write-Host "There are three flowers in a vase, the third flower is " -ForegroundColor Magenta -NoNewline
    Write-Host "green" -ForegroundColor Green -NoNewline
    Write-Host "." -ForegroundColor Magenta
}


################ Questions about Script or Paramter Validation? ################






################ Command Status and Error Variables ################

#Like most scripting languages, PowerShell tracks a command's success and failure.

#Dos commands are tracked using exit codes.
#An exit code of zero means the command ran without error. Anything else is considered an error.
#The exit code is not returned to the screen, but you can find it in the $LASTEXITCODE variable.

net statistics server
$LASTEXITCODE

#Now, let's make it fail...
net statistics ermahgerd
$LASTEXITCODE


#If using only PowerShell commands, you would track through the dollar hook ($?) variable.

#After every command execution, the $? varaible is populated with a boolean: $true for success or $false for failure.
Get-ADUser jmilczek
$?

#Now, let's make it fail...
Get-ADUser jmilczek12345
$?

#Some commands can be tricky, however. You should test for these results rather than making assumptions.
#In the next example we'll use the filter parameter to find the jmilczek12345 user.
Get-ADUser -Filter "samaccountname -eq 'jmilczek12345'"
$?
#Technically, the command was successful. It successfully performed a search query.


#Even more detail about errors is kept in a variable called $error.
#Check out all the properties we see when we look at the last error through Get-Member.
$error[0] | Get-Member

#PowerShell also provides a Try/Catch feature for trapping errors
#With Try/Catch, if anything in the Try block fails, the script stops and runs the contents of the Catch block.
#Terminating vs Non-terminating
$ErrorActionPreference = "Stop"
try {

    Get-ADUser jmilczek12345

}
catch {

    Write-Output "Get-ADUser failed with error: $($_.Exception.Message)."

}
#The "$_" variable within the Catch block provides details on the error.


################ Questions about command status or error variables? ################






################ Error Logging ################

#You have a couple of options for logging errors in PowerShell.

#Here is an example of writing errors to a text file.
$ErrorActionPreference = "Stop"
$LogFilePath = (".\" + (get-date -Format yyyyMMdd) + "-errorlog.txt")
try {

    Get-ADUser jmilczek12345

}
catch {

    Write-Output "`nGet-ADUser failed with error: $($_.Exception.Message)." | Out-File -FilePath $LogFilePath -Append

}

#Here is an example of writing errors to the local event log.
New-EventLog -LogName Application -Source "My Script" -ErrorAction SilentlyContinue
$ErrorActionPreference = "Stop"
try {

    Get-ADUser jmilczek12345

}
catch {

    Write-EventLog -LogName Application -Source "My Script" -EntryType Error -Message $($_.Exception.Message) -EventId 9999

}

#Why use functions? Reusable code blocks...Input / Return...Order

#Function Example
function Write-Error {

    param($message)
    Write-EventLog -LogName Application -Source "My Script" -EntryType Error -Message $message -EventId 9999
    Write-Output "`nGet-ADUser failed with error: $message." | Out-File -FilePath $LogFilePath -Append

}
#Why no error on screen?
#How about an alert?



################ Questions / Requests? ################