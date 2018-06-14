$Credential = (Get-Credential -Message 'Enter your credentials')

$Params = @{
    Credential = $Credential
    HostName   = 'allegro-mm-6cb3'
    Timespan   = 600
    Global     = $true
}
$IpStatisticColl = Get-MultimeterIpStatistics @Params

$IpStatisticColl
$IpStatisticColl.globalCounters
$IpStatisticColl.tcpStats
