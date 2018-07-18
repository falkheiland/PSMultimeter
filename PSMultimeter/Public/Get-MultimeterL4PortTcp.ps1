function Get-MultimeterL4PortTcp
{
    <#
    .SYNOPSIS
    Get TCP Ports from L4 Server Port Statistics from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get TCP Ports from L4 Server Port Statistics from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('bytes', 'serverPort', 'packets', 'bps', 'pps')

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
    Get-MultimeterL4PortTcp -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get TCP Ports from L4 Server Port Statisticsfrom Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterL4PortTcp -Hostname 'allegro-mm-6cb3' -SortBy bytes -Reverse -Page 0 -Count 3).displayedItems
    #Get the 3 TCP L4 Server Ports with most bytes transfered

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

        [ValidateSet('bytes', 'serverPort', 'packets', 'bps', 'pps')]
        [string]
        $SortBy = 'bytes',

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
        $BaseURL = ('https://{0}/API/stats/modules/l4_ports' -f $HostName)
        $SessionURL = ('{0}/tcp_ports_paged?sort={1}&reverse={2}&page={3}&count={4}&values={5}&timespan={6}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Values, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}