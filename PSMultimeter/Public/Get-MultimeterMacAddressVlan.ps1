function Get-MultimeterMacAddressVlan
{
    <#
    .SYNOPSIS
    Get Vlans for MAC Address from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Vlans for MAC Address from the Allegro Multimeter via RESTAPI.

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
    Get-MultimeterMacAddressVlan -Hostname 'allegro-mm-6cb3' -MACAddress c2:ea:e4:87:3d:89 -Credential $Credential
    #Ask for credential then get Vlans for MAC Address c2:ea:e4:87:3d:89 from Allegro Multimeter using provided credential

    .EXAMPLE
    ((Get-MultimeterMacAddressVlan -Hostname 'allegro-mm-6cb3' -MACAddress 'c2:ea:e4:87:3d:89').displayedItems).Where{$_.outerVlanTag -ne '-1'}
    #Get MAC-Statistics for Vlans which are not the default VLAN for MAC Address 'c2:ea:e4:87:3d:89'

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
        $SessionURL = ('{0}/macs/{1}/vlan_paged?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
            $MACAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}