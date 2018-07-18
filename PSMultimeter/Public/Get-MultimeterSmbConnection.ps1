function Get-MultimeterSmbConnection
{
    <#
    .SYNOPSIS
    Get SMB Connections from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get SMB Connections from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('clientIp', 'clientPort', 'serverIp', 'serverPort', 'packets', 'pps', 'bps')

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
    Get-MultimeterSmbConnection -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Yyy from Xxx from Allegro Multimeter using provided credential

    .EXAMPLE
    (((Get-MultimeterSmbConnection -Hostname 'allegro-mm-6cb3' -Count 999).displayedItems).where{$_.requestedDialects -match 'LANMAN.+'}).serverIp |
        Select-Object -Unique | Sort-Object
    #Get Server IPs where SMB connections run with dialect LANMAN'
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

        [ValidateSet('clientIp', 'clientPort', 'serverIp', 'serverPort', 'packets', 'pps', 'bps')]
        [string]
        $SortBy = 'clientIp',

        [switch]
        $Reverse,

        [int]
        $Page = 0,

        [int]
        $Count = 5,

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
        $SessionURL = ('{0}/connections?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}