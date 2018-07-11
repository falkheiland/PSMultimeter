function Get-MultimeterIpStatistic
{
    <#
    .SYNOPSIS
    Get IP Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get IP Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER IPAddress
    Ip-Address to get statistics for

    .PARAMETER SortBy
    Property to sort by ('bps', 'pps', 'bytes' or 'packets')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER Overview
    Switch to get statistics for IPAdress

    .PARAMETER Protocols
    Switch to get statistics for Protocols

    .PARAMETER Peers
    Switch to get statistics for Peers

    .PARAMETER Connections
    Switch to get statistics for Connections

    .PARAMETER Ports
    Switch to get statistics for Ports

    .PARAMETER Global
    Switch to get global IP statistics

    .PARAMETER Page
    Pagenumber

    .PARAMETER Count
    Number of Items per Page

    .PARAMETER Location
    Code for location (i.e. LO for local)

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get IP-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
    #Get IP-Statistics for the IP Address with the most Bytes in the last 1 hour

    .EXAMPLE
    Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Page 0 -Count 1 -Reverse -Location 'DE'
    #Get IP-Statistics for the IP Address with the most Bytes in the last 1 hour from Location Germany

    .EXAMPLE
    Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Overview
    #Get overview of IP-Statistics for IP Address '192.168.0.1'

    .EXAMPLE
    Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Protocols
    #Get IP-Statistics for Protocols for IP Address '192.168.0.1'

    .EXAMPLE
    (Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Timespan 60 -Protocols).protocols.Youtube.bytesFrom
    #Get Bytes received from for Protocol Youtube for IP Address '192.168.0.1' during the last 60 seconds

    .EXAMPLE
    Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Peers
    #Get IP-Statistics for Peers for IP Address '192.168.0.1'

    .EXAMPLE
    $Peer = (Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Peers -SortBy Bytes -Reverse -Count 1).displayedItems
    'http://maps.google.com/?ll={0},{1}' -f ($Peer.latitude -replace(',','.')), ($Peer.longitude -replace(',','.'))
    #Get the Peer for IP Address '192.168.0.1' with te most Bytes used and converts its Geolocation to Google Maps URL

    .EXAMPLE
    Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Connections
    #Get IP-Statistics for Connections for IP Address '192.168.0.1'

    .EXAMPLE
    (Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Connections -SortBy Bytes -Reverse -Page 3 -Count 1).displayedItems.server.dnsName
    #Get DNS Name of the Server with the 3rd most Connections to IP Address '192.168.0.1'

    .EXAMPLE
    Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Ports
    #Get IP-Statistics for Ports for IP Address '192.168.0.1'

    .EXAMPLE
    Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Global
    #Get Global IP-Statistics

    .EXAMPLE
    $Stats = (Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Global).tcpStats
    'Retransmissions: {0}%' -f [math]::Round(($Stats.globalRetransmissionBytes*100/$Stats.globalTotalBytes),3)
    #Get Retransmissions in Percent from Global IP-Statistics

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'IPAddresses')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [Parameter(ParameterSetName = 'IPAddress')]
        [Parameter(ParameterSetName = 'IPAddressProtocols')]
        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [Parameter(ParameterSetName = 'IPAddressPorts')]
        [ValidateScript( {$_ -match [IPAddress]$_})]
        [string]
        $IPAddress,

        [string]
        [Parameter(ParameterSetName = 'IPAddresses')]
        [Parameter(ParameterSetName = 'IPAddressesLocation')]
        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        $SortBy = 'bytes',

        [Parameter(ParameterSetName = 'IPAddresses')]
        [Parameter(ParameterSetName = 'IPAddressesLocation')]
        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'IPAddress')]
        [switch]
        $Overview,

        [Parameter(ParameterSetName = 'IPAddressProtocols')]
        [switch]
        $Protocols,

        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [switch]
        $Peers,

        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [switch]
        $Connections,

        [Parameter(ParameterSetName = 'IPAddressPorts')]
        [switch]
        $Ports,

        [Parameter(ParameterSetName = 'GlobalIPStats')]
        [switch]
        $Global,

        [Parameter(ParameterSetName = 'IPAddresses')]
        [Parameter(ParameterSetName = 'IPAddressesLocation')]
        [Parameter(ParameterSetName = 'IPAddressProtocols')]
        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'IPAddresses')]
        [Parameter(ParameterSetName = 'IPAddressesLocation')]
        [Parameter(ParameterSetName = 'IPAddressProtocols')]
        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [int]
        $Count = 5,

        [Parameter(ParameterSetName = 'IPAddressesLocation')]
        [string]
        $Location,

        [int]
        $Timespan = 1,

        [int]
        $Values = 50
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/ip' -f $HostName)
        switch ($PsCmdlet.ParameterSetName)
        {
            IPAddresses
            {
                $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            IPAddressesLocation
            {
                $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&countryfilter={5}&timespan={6}&values={7}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Location, $Timespan, $Values)
            }
            IPAddress
            {
                $SessionURL = ('{0}/ips/{1}?timespan={2}&values={3}' -f $BaseURL, $IPAddress, $Timespan, $Values)
            }
            IPAddressProtocols
            {
                $SessionURL = ('{0}/ips/{1}/protocols?timespan={2}&values={3}' -f $BaseURL, $IPAddress, $Timespan, $Values)
            }
            IPAddressPeers
            {
                $SessionURL = ('{0}/ips/{1}/peers?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
                    $IPAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            IPAddressConnections
            {
                $SessionURL = ('{0}/ips/{1}/connections?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
                    $IPAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            IPAddressPorts
            {
                $SessionURL = ('{0}/ips/{1}/ports?timespan={2}&values={3}' -f $BaseURL, $IPAddress, $Timespan, $Values)
            }
            GlobalIPStats
            {
                $SessionURL = ('{0}?timespan={1}' -f $BaseURL, $Timespan)
            }
        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}