<#
.SYNOPSIS
    Scrapes EVTX log files
.DESCRIPTION
    Scrapes EVTX log files found using wevutil for amount of time x minutes. Output as text data.
    Default 60 minutes. Default output in $env:TEMP\ScrapedLogs.txt
.EXAMPLE Check all logs for the term "Windows Defender" in the past hour
    PS/> Scrape-logs "Windows Defender" 60
.EXAMPLE Check all logs for the term "Windows Defender" and output to c:\testdata.txt
    PS/> Scrape-logs "Windows Defender" -OutFile "c:\testdata.txt"
.NOTES
    Time is reference by minute. 1 hour = 60, 1 day = 1440, 1 week = 10080, 1 month ~= 43800, 1 year ~= 525600
.LINK
    Github repo: https://github.com/redcanaryco/atomic-red-team
#>
function Scrape-Logs {
    [CmdletBinding(DefaultParameterSetName = 'commands',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        ConfirmImpact = 'Medium')]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = 'commands')]
        [ValidateNotNullOrEmpty()]
        [String]
        $SearchString,
        [Parameter(Mandatory = $false,
            Position = 1,
            ParameterSetName = 'commands')]
        [int]
        $Time = 60,
        [Parameter(Mandatory = $false,
            Position = 2,
            ParameterSetName = 'commands')]
        [String]
        $OutFile = $env:TEMP + "\ScrapedLogs.txt"
    )

    $logList = wevtutil el
    $Time = $Time * 60 * 1000
	$found = $false
    foreach($log in $logList){
        $events = wevtutil qe $log /q:"*[System[TimeCreated[timediff(@SystemTime) <= $Time]]]" /f:text
        $events = Out-String -InputObject $events
        $events = [regex]::Split($events, 'Event\[\d+\]:')
        foreach($event in $events) {
            if ($event -Match $SearchString) {
				$found = $true
                $event | Out-File -FilePath $OutFile -Append
            }
        }
    }
	if ($found){
		Write-Host "Logs found and saved to: " $OutFile
	}
	else{
		Write-Host "No logs found :("
	}
}
