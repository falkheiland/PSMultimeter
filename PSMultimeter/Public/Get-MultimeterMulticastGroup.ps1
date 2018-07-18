function Get-MultimeterMulticastGroup
{
    <#
    .SYNOPSIS
    Get Multicast Groups from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Multicast Groups from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'multicastActivity', 'activity', 'numberOfClients')

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
    Get-MultimeterMulticastGroup -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Multicast Groups from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterMulticastGroup -Hostname 'allegro-mm-6cb3' -Page 0 -Count 10 -SortBy numberOfClients -Reverse).displayedItems.ip
    #Gets IP for the 10 Groups with the most Number of Clients from Multicast-Statistics from Allegro Multimeter

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

        [ValidateSet('ip', 'multicastActivity', 'activity', 'numberOfClients')]
        [string]
        $SortBy = 'ip',

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
        $BaseURL = ('https://{0}/API/stats/modules/multicast' -f $HostName)
        $SessionURL = ('{0}/groups_paged?sort={1}&reverse={2}&page={3}&count={4}&values={5}&timespan={6}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Values, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}