function Get-MultimeterNetbiosStatistic
{
    <#
    .SYNOPSIS
    Get NetBIOS Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get NetBIOS Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'name', 'group')

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
    Get-MultimeterNetbiosStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get NetBIOS-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterNetbiosStatistic -Hostname 'allegro-mm-6cb3' -SortBy 'ip' -Page 0 -Count 20 -Timespan 3600).displayedItems.name
    #Get names of the first 20 IP Addresses for the last 1 hour

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

        [ValidateSet('ip', 'name', 'group')]
        [string]
        $SortBy = 'ip',

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
        $BaseURL = ('https://{0}/API/stats/modules/netbios' -f $HostName)
        $SessionURL = ('{0}/ips?sort={1}&page={2}&count={3}&timespan={4}' -f $BaseURL,
            $SortBy, $Page, $Count, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}