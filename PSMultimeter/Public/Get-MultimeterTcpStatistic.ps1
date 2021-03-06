function Get-MultimeterTcpStatistic
{
    <#
    .SYNOPSIS
    Get TCP statistics from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get TCP statistics from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER History
    Switch, Skip History Data, Default True

    .PARAMETER Page
    Pagenumber

    .PARAMETER Count
    Number of Items per Page

    .PARAMETER Timespan
    Timespan

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get TCP statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    ((Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -SortBy min -Page 0 -Count 100).displayedItems.where{$_.tcpSynResponseTimes.score -le 3 }).ip
    #Get IP from TCP-Statistics for IP Addresses sorted from 100 by minimal Handshaketime with a tcpSynResponseTimes score from 3 or less (problematic or worse)

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

        [ValidateSet('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')]
        [string]
        $SortBy = 'ip',

        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'Handshake')]
        [switch]
        $History,

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
        $BaseURL = ('https://{0}/API/stats/modules/ip' -f $HostName)
        $HistoryString = Get-MultimeterSwitchString -Value $History
        $SessionURL = ('{0}/ipsTCP?sort={1}&reverse={2}&page={3}&count={4}&skiphistorydata={5}&timespan={6}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $HistoryString, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}