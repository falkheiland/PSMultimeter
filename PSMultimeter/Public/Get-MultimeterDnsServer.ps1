function Get-MultimeterDnsServer
{
    <#
    .SYNOPSIS
    Get DNS Servers from DNS Statistics from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get DNS Servers from DNS Statistics from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('requests', 'ip', 'name', 'dns_server')

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
    Get-MultimeterDnsServer -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get DNS Servers from DNS Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterDnsServer -Hostname 'allegro-mm-6cb3' -Reverse -Count 1).displayedItems.allTime[0]
    #Get number of responses for the Server with the most responses

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

        [ValidateSet('full')]
        [string]
        $Details = 'full',

        [ValidateSet('requests', 'ip', 'name', 'dns_server')]
        [string]
        $SortBy = 'requests',

        [switch]
        $Reverse,

        [int]
        $Page = 0,

        [int]
        $Count = 5,

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
        $BaseURL = ('https://{0}/API/stats/modules/dns' -f $HostName)
        $SessionURL = ('{0}/servers_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}