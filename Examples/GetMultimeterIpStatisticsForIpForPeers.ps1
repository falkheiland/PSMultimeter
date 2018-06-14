$Credential = (Get-Credential -Message 'Enter your credentials')

$Params = @{
    Credential = $Credential
    HostName   = 'allegro-mm-6cb3'
    IPAddress  = '10.11.11.1'
    SortBy     = 'bytes'
    Reverse    = $true
    Count      = 10
    Timespan   = 600
    Values     = 50
    Peers      = $true
}
$IpStatisticColl = Get-MultimeterIpStatistics @Params

$IpStatisticColl.displayedItems
