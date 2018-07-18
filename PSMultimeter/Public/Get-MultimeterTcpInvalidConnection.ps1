function Get-MultimeterTcpInvalidConnection
{
    <#
    .SYNOPSIS
    Get TCP Server with invalid connections from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get TCP Server with invalid connections from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Details
    Details ('full')

    .PARAMETER SortBy
    Property to sort by ('invalidfactortcp', 'invalidconnections', 'validconnections')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER Dosview
    Switch, Dosview, Default True

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
    Get-MultimeterTcpInvalidConnection -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get TCP Server with invalid connections from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterTcpInvalidConnection -Hostname 'allegro-mm-6cb3' -Reverse -Page 0 -Count 3).displayedItems
    #Get TCP-Statistics for the 3 IP Addresses with the highest Invalid connections

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

        [ValidateSet('invalidfactortcp', 'invalidconnections', 'validconnections')]
        [string]
        $SortBy = 'invalidconnections',

        [switch]
        $Reverse,

        [switch]
        $Dosview,

        [int]
        $Page = 0,

        [int]
        $Count = 10,

        [int]
        $Timespan = 60,

        [int]
        $Values = 60
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/ip' -f $HostName)
        $DosviewString = Get-MultimeterSwitchString -Value $Dosview
        $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&values={5}&dosview={6}&timespan={7}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Values, $DosviewString , $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}