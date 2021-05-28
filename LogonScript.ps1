<#
    LogonScript v1.4
   This script will retrieve the user data which logs to an Active Directory domain for logging purposes.
   Data retrieved contains Date(yyyyMMdd HH:ss), Domain used, Username, Computer name, IP Address and is wroten each time an user connect. 
   Data is stored on a shared drive.
   Script writeen by Arnaud Collart the 15/04/2021.
   Documentation can be found on : https://www.temporaryURL.com/doc/mydoc 
#>

#Variables definition

$date = Get-Date -Format yyyyMM
$Header = "LogonDate;DomainName;PCName;LoginName;IPAddress"
$logonDate = Get-Date -Format yyyy/MM/dd-HH:mm:ss
$domainName = $env:USERDOMAIN
$computerName = $env:COMPUTERNAME
$userName = $env:USERNAME
$ipAddress = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress
$OutInfo = $logonDate + ";" + $domainName + ";" + $computerName + ";" + $userName + ";" + $ipAddress
$filepath = "\\share\grafana\logs\$env:USERDNSDOMAIN\"
$outfile = "\\share\grafana\logs\$env:USERDNSDOMAIN\$date-$env:USERDNSDOMAIN-ADLogon.csv"

#Checks if CSV has already been created for the day/is accessible. If already exists, appends existing file.

if (Test-path $filepath) {
    if (Test-path $outfile){
        Add-Content -Value $OutInfo -Path $outfile
    }
    else{
        Add-Content -Value $Header -Path $outfile
        Add-Content -Value $OutInfo -Path $outfile
    } 
}
else{
    Exit    
}
