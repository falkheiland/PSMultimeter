function Get-MultimeterIpAddressPeer
{
    <#
    .SYNOPSIS
    Get Peers for IP Address from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Peers for IP Address from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER IPAddress
    Ip-Address to get statistics for

    .PARAMETER SortBy
    Property to sort by ('ip', 'firstActivity', 'activity', 'packets', 'bytes', 'pps', 'bps')

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
    Get-MultimeterIpAddressPeer -Hostname 'allegro-mm-6cb3' -IPAddress '10.11.11.1' -Credential $Credential
    #Ask for credential then get Peers for IP Address from Allegro Multimeter using provided credential

    (Get-MultimeterIpAddressPeer -Hostname 'allegro-mm-6cb3' -IPAddress '10.11.11.1' -SortBy Bytes -Reverse -Count 1).displayedItems
    #Get the Peer for IP Address '192.168.0.1' with te most Bytes used

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

        [Parameter(Mandatory)]
        [ValidateScript( {$_ -match [IPAddress]$_})]
        [string]
        $IPAddress,

        [ValidateSet('ip', 'firstActivity', 'activity', 'packets', 'bytes', 'pps', 'bps')]
        [string]
        $SortBy = 'ip',

        [switch]
        $Reverse,

        [int]
        $Page = 0,

        [int]
        $Count = 5,

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
        $BaseURL = ('https://{0}/API/stats/modules/ip' -f $HostName)
        $SessionURL = ('{0}/ips/{1}/peers?sort={2}&reverse={3}&page={4}&count={5}&timespan={6}&values={7}' -f $BaseURL,
            $IPAddress, $SortBy, $ReverseString, $Page, $Count, $Timespan, $Value)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}