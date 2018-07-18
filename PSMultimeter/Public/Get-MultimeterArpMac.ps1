function Get-MultimeterArpMac
{
    <#
    .SYNOPSIS
    Get Arp statistics MAC addresses from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Arp statistics MAC addresses from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

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

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterArpMac -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Arp statistics MAC addresses from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterArpMac -Hostname 'allegro-mm-6cb3' -SortBy bytes -Reverse -Page 0 -Count 1 -Timespan 60).displayedItems.mac
    #Get MAC Address for the Host with most bytes in the last hour

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
        $Timespan = 60
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/arp' -f $HostName)
        $SessionURL = ('{0}/macs?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}