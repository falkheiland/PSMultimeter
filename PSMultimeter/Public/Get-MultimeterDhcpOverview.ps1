function Get-MultimeterDhcpOverview
{
    <#
    .SYNOPSIS
    Get DHCP Overview from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get DHCP Overview from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('aaa', 'bbb', 'ccc', 'ddd')

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
    Get-MultimeterDhcpOverview -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get DHCP Overview from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterDhcpOverview -Hostname 'allegro-mm-6cb3' -SortBy 'ip' -Page 0 -Count 20 -Timespan 3600).displayedItems.hostName
    #Get Hostnames of the first 20 IP Addresses for the last 1 hour

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

        [ValidateSet('issueTime', 'ip', 'name', 'mac')]
        [string]
        $SortBy = 'issueTime',

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
        $BaseURL = ('https://{0}/API/stats/modules/dhcp' -f $HostName)
        $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}