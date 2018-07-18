function Get-MultimeterSslResponse
{
    <#
    .SYNOPSIS
    Get Response statistics from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Response statistics from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')

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
    Get-MultimeterSslResponse -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Response statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterSslResponse -Hostname 'allegro-mm-6cb3' -SortBy min -Page 0 -Count 1).displayedItems.sslHelloResponseTimes.score
    #Get SSL-Handshake-score of the SSL-Server with the lowest response time

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

        [ValidateSet('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')]
        [string]
        $SortBy = 'ip',

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
        $BaseURL = ('https://{0}/API/stats/modules/ssl' -f $HostName)
        $SessionURL = ('{0}/response-stats?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}