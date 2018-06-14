$Credential = (Get-Credential -Message 'Enter your credentials')

$Params = @{
    Credential = $Credential
    HostName   = 'allegro-mm-6cb3'
    IPAddress  = '10.11.11.1'
    Timespan   = 600
    Values     = 50
}
$IpStatisticColl = Get-MultimeterIpStatistics @Params

$IpStatisticColl
