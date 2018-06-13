$Params = @{
    HostName = '10.11.11.35'
    SortBy   = 'bytes'
    Reverse  = $true
    Count    = 10
    Timespan = 600
    Values   = 50
}
$IpStatisticColl = Get-MultimeterIpStatistics @Params
$IpStatisticColl.displayedItems | ForEach-Object {
    $Probs = @{
        IP       = $_.IP
        MBytesRx = [math]::round($_.l7RealBytesRx / 1MB)
    }
    New-Object -TypeName psobject -Property $Probs
} | Sort-Object -Property MBytesRx -Descending
