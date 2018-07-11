function Get-MultimeterL4serverportStatistic
{
    <#
    .SYNOPSIS
    Get L4 Server Port Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get L4 Server Port Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER TCPPort
    TCP Port to get statistics for

    .PARAMETER SortBy
    Property to sort by ('bytes', 'serverPort', 'packets', 'bps', 'pps')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER TCP
    Switch to get statistics for TCP

    .PARAMETER PortStats
    Switch to get statistics for TCP Server Port

    .PARAMETER UDP
    Switch to get statistics for UDP

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
    Get-MultimeterL4serverportStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get L4 Server Port Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterL4serverportStatistic -Hostname 'allegro-mm-6cb3' -TCP -SortBy bytes -Reverse -Page 0 -Count 3).displayedItems
    #Get the 3 TCP L4 Server Ports with most bytes transfered

    .EXAMPLE
    Get-MultimeterL4serverportStatistic -Hostname 'allegro-mm-6cb3' -PortStats -TCPPort 443
    #Get L4 Server Port Statistics TCP PortStats

    .EXAMPLE
    (Get-MultimeterL4serverportStatistic -Hostname 'allegro-mm-6cb3' -UDP -SortBy bytes -Reverse -Page 0 -Count 3).displayedItems
    #Get the 3 UDP L4 Server Ports with most bytes transfered

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'TCP')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [Parameter(ParameterSetName = 'PortStats')]
        [ValidateRange(1, 4096)]
        [int]
        $TCPPort,

        [Parameter(ParameterSetName = 'TCP')]
        [Parameter(ParameterSetName = 'UDP')]
        [ValidateSet('bytes', 'serverPort', 'packets', 'bps', 'pps')]
        [string]
        $SortBy = 'bytes',

        [Parameter(ParameterSetName = 'TCP')]
        [Parameter(ParameterSetName = 'UDP')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'TCP')]
        [switch]
        $TCP,

        [Parameter(ParameterSetName = 'PortStats')]
        [switch]
        $PortStats,

        [Parameter(ParameterSetName = 'UDP')]
        [switch]
        $UDP,

        [Parameter(ParameterSetName = 'TCP')]
        [Parameter(ParameterSetName = 'UDP')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'TCP')]
        [Parameter(ParameterSetName = 'UDP')]
        [int]
        $Count = 5,

        [int]
        $Timespan = 60,

        [Parameter(ParameterSetName = 'TCP')]
        [Parameter(ParameterSetName = 'UDP')]
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
        switch ($PsCmdlet.ParameterSetName)
        {
            TCP
            {
                $SessionURL = ('{0}/tcp_ports_paged?sort={1}&reverse={2}&page={3}&count={4}&values={5}&timespan={6}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Values, $Timespan)
            }
            PortStats
            {
                $SessionURL = ('{0}/tcp_port/{1}?timespan={2}' -f $BaseURL, $TCPPort, $Timespan)
            }
            UDP
            {
                $SessionURL = ('{0}/udp_ports_paged?sort={1}&reverse={2}&page={3}&count={4}&values={5}&timespan={6}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Values, $Timespan)
            }

        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}