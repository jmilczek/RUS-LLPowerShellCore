#PowerShell Lunch & Learn – Day 2: Input, Variables, String Manipulation, Output




#A variable is simplying storing data in memory. It is convenient, some cmdlets require it and there are speed advantages when dealing with external data sources.

#Creating variables in PowerShell is more convenient when compared to many other scripting languages. PowerShell will create a variable of the appropriate type (string,integer,date) automatically...all you have to do is assign a value.

$ComputerName = "Computer1"
$Date = Get-Date

#We can pipe this variable to the Get-Member cmdlet to see it's Type.
$ComputerName | Get-Member
$Date | Get-Member


#It is possible to force a varaiable type through Type Casting.
#See how the Type changes when the variable is prefixed with the type "[DateTime]".
$ManualDate = "06/27/2001"
$ManualDate | Get-Member

Remove-Variable ManualDate

[DateTime]$ManualDate = "06/27/2001"
$ManualDate | Get-Member


#Dot Notation Examples
$Date.DayOfWeek
(Get-Date).DayOfWeek


#Dot Notation Method Examples
$Date.AddDays(60)
$Date.AddDays(-60)

#A variable can also contain multiple objects. This is called an array.
$Services = Get-Service
$Users = Get-ADUser -filter "givenname -like 'John'" -Properties *

#You can access an individual item in an array by calling an index number which counts from 0.
$Services[0]
$Services[1]
$Services[2]

#Check out the methods available an object from Get-Service
$Services[0] | Get-Member
$Services[0].Stop()
$Services[0].Start()

#Strings also have methods available.
#We can use this to extract the hostname from the FQDN in $Computername above.
$ComputerName.Split(".")[0]
$ComputerName.Replace("domain.com","domain.ca")
$ComputerName.Split(".")

#Demo some additional string methods if time permits.
$string = "     Mike goes to the store to buy a soda."
$string.toupper()
$string.trim()
$string.replace("Mike","Brad")

#The following command will return the first 4 characters of the hostname.
$ComputerName.Substring(0,4)



################ Questions about variables or dot notation? ################




#PowerShell offers several types of output.
#You can output to the screen, a file or other cmdlets.

#There are multiple ways to output to the screen.
#Most commands automatically output to the screen, but you can also combine this data with a string to make it friendly.
Write-Host $ComputerName -ForegroundColor Cyan
Write-Output $ComputerName
Write-Output "The computername"
Write-Output "The computername is $ComputerName"
#But dot notation doesn't seem to work the same way inside a string.
Write-Host "The computername is $ComputerName.Split(".")[0]"
#Surround your expression with $() to accomplish the same result.
Write-Host "The computername is $($ComputerName.Split(".")[0])"
Write-Host "The computername is $($ComputerName.toupper())"

#You can also choose how data is displayed on the screen like we did with Select-Object.

#Format-Table (or ft) will organize data in a tabular format.
$Services | ft
#You can choose which fields are displayed similar to Select-Object.
$Services | ft DisplayName,StartType,Status -AutoSize

#The Format-List (or fl) command will display results in a list format.
$Services | fl *
#The command above will display results very similar to "Select *"...
#The difference: Format-x cmdlets are similar to write-host in that they output strings instead of the original objects.

#Questions about screen output?



#Sometimes you want to output to a file.

#You can output to a text file with no structure using the Out-File cmdlet.
Write-Output "The computername is $ComputerName" | Out-File -FilePath .\log.txt -Append
#Out-File is best used for logging.

#For structured data, you'll want to use a cmdlet like Export-CSV.
$Services | Export-Csv -Path .\services.csv
$users | Export-Csv .\johns.csv -NoTypeInformation

################ Questions about file output? ################



############################################
################ TIME CHECK ################
############################################



#A script typically has an input of some sort of input.

#Often we need dynamic input from the person (or process) executing the script.
param (

    $Name,
    $Location

)
#A param block should be at the top of the script.

################ Parameter/Hello World Demo ################




################ Questions about parameter blocks? ################


############################################
################ TIME CHECK ################
############################################



#Another common scenario involves gathering data from a file.
#The less common approach is unstructured data from a text file.
Get-Content -Path .\log.txt
$logcontent = Get-Content -Path .\log.txt

#The most common approach is structured data from a CSV file.
Import-Csv -Path  .\services.csv
$services_csv = Import-Csv -Path  .\services.csv

#We access the imported csv the same as we did with the $Services variable earlier.
$services_csv
$services_csv[0] | select *
$services_csv[0].DisplayName



################ IGNORE UNLESS YOU HAVE TIME ################

#Which is faster?
$test1 = Get-ADUser -filter "givenname -like 'John'" -Properties * -ResultSetSize $null
$test2 = Get-ADUser -filter * -Properties * -ResultSetSize $null | where {$_.givenname -like "John"}
Get-History | Select-Object CommandLine,*time* -last 2

#Which is faster?
$test2 | Select-Object DisplayName,UserPrincipalName | Sort-Object DisplayName
$test2 | Sort-Object DisplayName | Select-Object DisplayName,UserPrincipalName
Get-History | Select-Object CommandLine,*time* -last 2

Get-Clipboard
(Get-Clipboard).ToUpper() | Set-Clipboard
1..10 | foreach{Write-Output "I can count to $_"}
