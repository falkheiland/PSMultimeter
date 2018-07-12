function Get-MultimeterSmbShare
{
    <#
    .SYNOPSIS
    Get SMB Shares from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get SMB Shares from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'name', 'connects', 'disconnects')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER DNSServer
    Switch to get DNS servers

    .PARAMETER GRT
    Switch to get Global response times

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
    Get-MultimeterSmbShare -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Yyy from Xxx form Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterSmbShare -Hostname 'allegro-mm-6cb3' -SortBy 'connects' -Reverse -Page 0 -Count 3 -Timespan 3600).displayedItems.share
    #Get UNC-Path of 3 most connected SMB shares in the last hour

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

        [ValidateSet('ip', 'name', 'connects', 'disconnects')]
        [string]
        $SortBy = 'ip',

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
        $BaseURL = ('https://{0}/API/stats/modules/smb' -f $HostName)
        $SessionURL = ('{0}/shares?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}