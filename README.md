# ScrapeLogs
Scrapes EVTX log files

## Description:
Scrapes EVTX log files found using wevutil for amount of time in X minutes for a particular term. Output as text data.
Default 60 minutes. Default output in $env:TEMP\ScrapedLogs.txt

## Use Cases:
Find out which logs contain whatever term you want to look for. 
I.e if you run a command and want to find out which files logged it or what is logging XYZ program.

## Getting Started:
To run the script import the module with powershell. It is recommended to do this in an Admin PowerShell prompt as wevtutil will need elevated permission to search most logs.

PS/> Import-Module YOURFILEPATH\ScrapeLogs.ps1

Note: If a PSSecurityException alert occurs, then the likely resolution is to lower your ExecutionPolicy to a less strict setting.
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.1

 ### Arguments:
 SYNTAX
    Scrape-Logs [-SearchString] <string> [[-Time] <int>] [[-OutFile] <string>] [-WhatIf] [-Confirm]
    [<CommonParameters>]
  
 - SearchString: search term to be found in event logs
 - Time: time in minutes to search. i.e. 30 = search 30 minutes ago. Default 60.
 - OutFile: file path to save output. Default $env:TEMP\ScrapedLogs.txt
 
 ## Examples
Check all logs for the term "Windows Defender" in the past hour
  
  PS/> Scrape-Logs "Windows Defender" 60

Check all logs for the term "Windows Defender" and output to c:\testdata.txt
  
  PS/> Scrape-Logs "Windows Defender" -OutFile "c:\testdata.txt"
