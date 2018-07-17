function Get-MultimeterHttpGlobalResponseCode
{
    <#
    .SYNOPSIS
    Get Global Response code count from HTTP statistics from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Global Response code count from HTTP statistics from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'requests', 'xx1', 'xx2', 'xx3', 'xx4', 'xx5', 'xx0')

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
    Get-MultimeterHttpGlobalResponseCode -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Global Response code count from HTTP statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterHttpGlobalResponseCode -Hostname 'allegro-mm-6cb3'-SortBy 'xx5' -Reverse -Count 1).displayedItems
    #Get the HTTP server with most Server Errors

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

        [ValidateSet('ip', 'requests', 'xx1', 'xx2', 'xx3', 'xx4', 'xx5', 'xx0')]
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
        $BaseURL = ('https://{0}/API/stats/modules/http' -f $HostName)
        $SessionURL = ('{0}/codes?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}