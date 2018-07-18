function Get-MultimeterMacAddressPeer
{
    <#
    .SYNOPSIS
    Get Peers for MAC Address from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Peers for MAC Address from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER MACAddress
    MAC-Address to get statistics for

    .PARAMETER SortBy
    Property to sort by ('bps', 'pps', 'bytes', 'packets')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

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
    Get-MultimeterMacAddressPeer -Hostname 'allegro-mm-6cb3' -MACAddress c2:ea:e4:87:3d:89 -Credential $Credential
    #Ask for credential then get Peers for MAC Address c2:ea:e4:87:3d:89 from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterMacAddressPeer -Hostname 'allegro-mm-6cb3' -MACAddress 'c2:ea:e4:87:3d:89' -SortBy Bytes -Reverse -Count 1).displayedItems.dhcpHostName
    #Get DHCP Name of the Peer for MAC Address 'c2:ea:e4:87:3d:89' with the most Bytes used

    .NOTES
    n.a.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [ValidatePattern('(([0-9A-Fa-f]{2}[-:]){5}[0-9A-Fa-f]{2})|(([0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4})')]
        [string]
        $MACAddress,

        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        [string]
        $SortBy = 'bytes',

        [switch]
        $Reverse,

        [int]
        $Page = 0,

        [int]
        $Count = 10,

        [int]
        $Timespan = 60,

        [int]
        $Values = 100
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/mac' -f $HostName)
        $SessionURL = ('{0}/macs/{1}/peer_paged?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
            $MACAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}