function Get-MultimeterNtpStatistic
{
    <#
    .SYNOPSIS
    Get SMB Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get SMB Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'activity', 'li', 'vn', 'poll', 'stratum', 'precision', 'rootDelay', 'rootDispersion', 'numberOfClients')

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
    Get-MultimeterNtpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get NTP Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterNtpStatistic -Hostname 'allegro-mm-6cb3'-SortBy activity -Reverse -Count 3).displayedItems.dnsName
    #Get DNS names form the 3 NTP server which were last activ

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

        [ValidateSet('ip', 'activity', 'li', 'vn', 'poll', 'stratum', 'precision', 'rootDelay', 'rootDispersion', 'numberOfClients')]
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
        $BaseURL = ('https://{0}/API/stats/modules/ntp' -f $HostName)
        $SessionURL = ('{0}?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}