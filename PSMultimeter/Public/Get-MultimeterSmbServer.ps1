function Get-MultimeterSmbServer
{
    <#
    .SYNOPSIS
    Get SMB Server from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get SMB Server from the Allegro Multimeter via RESTAPI.

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

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterSmbServer -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get SMB Server from Xxx form Allegro Multimeter using provided credential

    .EXAMPLE
    (((Get-MultimeterSmbServer -Hostname 'allegro-mm-6cb3' -Count 999).displayedItems).where{$_.usedDialects.name -match '^SMB 3.+'}).ip
    #Get SMB Server which use SMB Version 3

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

        [ValidateSet('ip')]
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
        $SessionURL = ('{0}/servers?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}