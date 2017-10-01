#PowerShell Lunch & Learn – Day 3: Conditional Execution and Looping

#Similar to other scripting languages, PowerShell offers a way to evaluate criteria before taking action.

#The "If" statement block is the most common method for conditional execution.
#If (Is This True) {Do This}
#Optional: Else If (This is True) {Do This Instead}
#Optional: Else {For Everything Else, Do This}

 If (Get-Service) {Write-Output "Success!"}

#Maybe we're looking for a particular service...
If (Get-Service -Name AdhocSettingService.exe -ErrorAction SilentlyContinue) {Write-Output "Success!"}

#And suppose we want to test to see if that service is running...
If ((Get-Service -Name AdhocSettingService.exe).Status -eq "Running") {Write-Output "The service is running."}

#You can add many lines within the curly braces.
$ServiceName = "AdhocSettingService.exe"
If ((Get-Service -Name $ServiceName).Status -eq "Running") {
    
    Write-Output "The $ServiceName service is running."
    Write-Output "Yo!"

}

#Let's add another condition with an "ElseIf" statement block.
#Start the service if it's stopped; stop the service if it is started.
$ServiceName = "AdhocSettingService.exe"
If ((Get-Service -Name $ServiceName).Status -eq "Running") {
    
    Write-Output "The $ServiceName service is running. Stopping service..."
    Stop-Service -Name $ServiceName -PassThru

}
ElseIf ((Get-Service -Name $ServiceName).Status -eq "Stopped") {

    Write-Output "The $ServiceName service is stopped. Starting service..."
    Start-Service -Name $ServiceName -PassThru

}
Else {Write-Output "The service state is unknown."}

#The other option for conditional execution in PowerShell is a "Switch" statement block.
#A Switch is like a targeted If statement looking for specific values rather than a true/false solution. Once a match is found, the associated code block is executed.
$user = Get-ADUser jmilczek -Properties *

switch ($user.City) {

    "Lawrenceville" {Write-Output "$($user.DisplayName) is located in Georgia"}
    "Macon"         {Write-Output "$($user.DisplayName) is located in Georgia"}
    "Memphis"       {Write-Output "$($user.DisplayName) is located in Tennessee"}
    "Tustin"       {Write-Output "$($user.DisplayName) is located in California"}
    Default        {Write-Output "$($user.DisplayName) is from Outer Space"}

}


################ Questions about Conditional Execution? ################





#PowerShell offers four options for looping through a collection of objects: Do Until, Do While, While, For and Foreach.
#The Do Until, Do While and While loops are not used very often and can put your script in an infinite loop if you aren't careful.

#Here is and example of a Do Until loop.
$i = 0
Do {

    Write-Output "The countdown is $i"
    $i++

}
Until ($i -eq 5)

#Here is an example of a Do While loop. Notice we use the "less than or equal to" operator this time.
$i = 0
Do {

    Write-Output "The countdown is $i"
    $i++

}
While ($i -le 5)
#In both examples above the code block is executed at least once since the Until or While evaluation is at the end.


#Here is an example of a For loop. This is rarely used.
#The condition is made up of 3 parts: counter initialization, condition, incremental.
For ($i = 0;$i -le 25;$i++) {

    Write-Output $i

}

#The most popular loop by far is the Foreach loop.
#Technically, there are still two different ways to execute this loop.

#This is the most simple form of Foreach: Foreach-Object.
Get-Service | ForEach-Object {Write-Output $_.DisplayName}
#Same thing, but multiline...
Get-Service | ForEach-Object {
 
    Write-Output $_.DisplayName

}
#Notice the example above makes use of the current pipeline variable "$_".

#Here is an example of Foreach. I recommend this style over the previous example.
foreach ($Service in $Services) {Write-Host $Service.DisplayName}
#Notice how we are no longer using the pipeline variable.
#Instead, we are defining the "$Service" variable on the fly and it will only be valid during the loop.

#Here is why I recommend Foreach over Foreach-Object.
#If I nest loops, using Foreach-Object, I cannot reference the outer and inner current object in the inner loop.

foreach ($ClientService in (Get-Service -ComputerName Computer1)) {

    foreach ($ServerService in (Get-Service -ComputerName Computer2)) {
    
        If ($ServerService.Name -like $ClientService.Name) {Write-Output $ServerService.DisplayName}

    }

}


#Now we'll do the same with variables instead of streaming each object remotely.
$ClientServices = Get-Service -ComputerName Computer1
$ServerServices = Get-Service -ComputerName Computer2

foreach ($ClientService in ($ClientServices)) {

    foreach ($ServerService in ($ServerServices)) {
    
        If ($ServerService.Name -like $ClientService.Name) {Write-Output $ServerService.DisplayName}

    }

}