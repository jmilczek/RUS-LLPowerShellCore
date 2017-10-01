$report = @()
$startdate = Get-Date
[datetime]$enddate = "1/1/2065"
for ($i = $startdate;$i -le $enddate;$i = $i.AddDays(1)) {

    If (($i.DayOfWeek -like "Friday") -and ($i.Day -like "13")) {$report += $i}

}
