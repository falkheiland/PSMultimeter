function Get-MultimeterMacStatistic
{
    <#
    .SYNOPSIS
    Get MAC Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get MAC Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER MACAddress
    MAC-Address to get statistics for

    .PARAMETER SortBy
    Property to sort by ('bps', 'pps', 'bytes' or 'packets')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER Overview
    Switch to get statistics overview

    .PARAMETER Protocols
    Switch to get statistics for Protocols

    .PARAMETER Peers
    Switch to get statistics for Peers

    .PARAMETER ActiveIPs
    Switch to get statistics for ActiveIPs

    .PARAMETER PeerCountries
    Switch to get statistics for PeerCountries

    .PARAMETER Vlans
    Switch to get global MAC statistics for Vlans

    .PARAMETER Page
    Pagenumber

    .PARAMETER Count
    Number of Items per Page

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get MAC-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
    #Get MAC-Statistics for the MAC with the most Bytes in the last 1 hour

    .EXAMPLE
    Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Overview
    #Get overview of IP-Statistics for MAC Address 'b4:ea:e4:87:3d:89'

    .EXAMPLE
    Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Protocols
    #Get MAC-Statistics for Protocols for MAC Address 'b4:ea:e4:87:3d:89'

    .EXAMPLE
    ((Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Timespan 60 -Protocols -Page 0 -Count 99).displayedItems).where{$_.protocol -eq 'youtube'}
    #Get Bytes received from for Protocol Youtube for MAC Address 'b4:ea:e4:87:3d:89' during the last 60 seconds

    .EXAMPLE
    Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Peers
    #Get MAC-Statistics for Peers for MAC Address 'b4:ea:e4:87:3d:89'

    .EXAMPLE
    (Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Peers -SortBy Bytes -Reverse -Count 1).displayedItems.dhcpHostName
    #Get DHCP Name of the Peer for MAC Address 'b4:ea:e4:87:3d:89' with te most Bytes used

    .EXAMPLE
    Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -ActiveIPs
    #Get MAC-Statistics for Connections for MAC Address 'b4:ea:e4:87:3d:89'

    .EXAMPLE
    (Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -ActiveIPs -SortBy Bytes -Reverse -Page 3 -Count 1).displayedItems.dnsName
    #Get DNS Name of the Server with the 3rd most Connections to MAC Address 'b4:ea:e4:87:3d:89'

    .EXAMPLE
    Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -PeerCountries
    #Get MAC-Statistics for Ports for MAC Address 'b4:ea:e4:87:3d:89'

    .EXAMPLE
    Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Vlans
    #Get MAC-Statistics for Vlans for MAC Address 'b4:ea:e4:87:3d:89'

    .EXAMPLE
    ((Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Vlans).displayedItems).Where{$_.outerVlanTag -ne '-1'}
    #Get MAC-Statistics for Vlans which are not the default VLAN for MAC Address 'b4:ea:e4:87:3d:89'

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'MACAddresses')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [Parameter(ParameterSetName = 'MACAddress')]
        [Parameter(ParameterSetName = 'MACAddressProtocols')]
        [Parameter(ParameterSetName = 'MACAddressPeers')]
        [Parameter(ParameterSetName = 'MACAddressActiveIPs')]
        [Parameter(ParameterSetName = 'MACAddressPeerCountries')]
        [Parameter(ParameterSetName = 'MACAddressVlans')]
        [ValidatePattern('(([0-9A-Fa-f]{2}[-:]){5}[0-9A-Fa-f]{2})|(([0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4})')]
        [string]
        $MACAddress,

        [string]
        [Parameter(ParameterSetName = 'MACAddresses')]
        [Parameter(ParameterSetName = 'MACAddressPeers')]
        [Parameter(ParameterSetName = 'MACAddressProtocols')]
        [Parameter(ParameterSetName = 'MACAddressActiveIPs')]
        [Parameter(ParameterSetName = 'MACAddressPeerCountries')]
        [Parameter(ParameterSetName = 'MACAddressVlans')]
        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        $SortBy = 'bytes',

        [Parameter(ParameterSetName = 'MACAddresses')]
        [Parameter(ParameterSetName = 'MACAddressPeers')]
        [Parameter(ParameterSetName = 'MACAddressProtocols')]
        [Parameter(ParameterSetName = 'MACAddressActiveIPs')]
        [Parameter(ParameterSetName = 'MACAddressPeerCountries')]
        [Parameter(ParameterSetName = 'MACAddressVlans')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'MACAddress')]
        [switch]
        $Overview,

        [Parameter(ParameterSetName = 'MACAddressProtocols')]
        [switch]
        $Protocols,

        [Parameter(ParameterSetName = 'MACAddressPeers')]
        [switch]
        $Peers,

        [Parameter(ParameterSetName = 'MACAddressActiveIPs')]
        [switch]
        $ActiveIPs,

        [Parameter(ParameterSetName = 'MACAddressPeerCountries')]
        [switch]
        $PeerCountries,

        [Parameter(ParameterSetName = 'MACAddressVlans')]
        [switch]
        $Vlans,

        [Parameter(ParameterSetName = 'MACAddresses')]
        [Parameter(ParameterSetName = 'MACAddressProtocols')]
        [Parameter(ParameterSetName = 'MACAddressPeers')]
        [Parameter(ParameterSetName = 'MACAddressActiveIPs')]
        [Parameter(ParameterSetName = 'MACAddressPeerCountries')]
        [Parameter(ParameterSetName = 'MACAddressVlans')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'MACAddresses')]
        [Parameter(ParameterSetName = 'MACAddressProtocols')]
        [Parameter(ParameterSetName = 'MACAddressPeers')]
        [Parameter(ParameterSetName = 'MACAddressActiveIPs')]
        [Parameter(ParameterSetName = 'MACAddressPeerCountries')]
        [Parameter(ParameterSetName = 'MACAddressVlans')]
        [int]
        $Count = 5,

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
        $BaseURL = ('https://{0}/API/stats/modules/mac' -f $HostName)
        switch ($PsCmdlet.ParameterSetName)
        {
            MACAddresses
            {
                $SessionURL = ('{0}/mac_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            MACAddress
            {
                $SessionURL = ('{0}/macs/{1}?timespan={2}&values={3}' -f $BaseURL, $MACAddress, $Timespan, $Values)
            }
            MACAddressProtocols
            {
                $SessionURL = ('{0}/macs/{1}/protocol_paged?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
                    $MACAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            MACAddressPeers
            {
                $SessionURL = ('{0}/macs/{1}/peer_paged?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
                    $MACAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            MACAddressActiveIPs
            {
                $SessionURL = ('{0}/macs/{1}/ip_paged?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
                    $MACAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            MACAddressPeerCountries
            {
                $SessionURL = ('{0}/macs/{1}/country_paged?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
                    $MACAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            MACAddressVlans
            {
                $SessionURL = ('{0}/macs/{1}/vlan_paged?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
                    $MACAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}