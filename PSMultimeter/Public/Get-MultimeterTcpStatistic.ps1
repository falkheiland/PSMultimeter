function Get-MultimeterTcpStatistic
{
    <#
    .SYNOPSIS
    Get TCP Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get TCP Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER IPAddress
    Ip-Address to get statistics for

    .PARAMETER SortByHandshake
    Property to sort by ('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')

    .PARAMETER SortByRetransmissions
    Property to sort by ('ip', 'txpayload', 'txretrans', 'txratio', 'rxpayload', 'rxretrans', 'rxratio')

    .PARAMETER SortByInvalidConnections
    Property to sort by ('ip', 'invalidfactortcp', 'invalidconnections', 'validconnections')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER Retransmissions
    Switch to get statistics for Retransmissions

    .PARAMETER InvalidConnections
    Switch to get statistics for InvalidConnections

    .PARAMETER History
    Switch, Skip History Data, Default True

    .PARAMETER Dosview
    Switch, Dosview, Default True

    .PARAMETER Page
    Pagenumber

    .PARAMETER Count
    Number of Items per Page

    .PARAMETER Location
    Code for location (i.e. LO for local)

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get TCP-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    ((Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -SortByHandshake min -Page 0 -Count 100).displayedItems.where{$_.tcpSynResponseTimes.score -le 3 }).ip
    #Get IP from TCP-Statistics for IP Addresses sorted from 100 by minimal Handshaketime with a tcpSynResponseTimes score from 3 or less (problematic or worse)

    .EXAMPLE
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -Retransmissions
    #Get TCP-Statistics TCP retransmissions

    .EXAMPLE
    (Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -Retransmissions -SortByRetransmissions txratio -Reverse -Page 0 -Count 1).displayedItems
    #Get TCP-Statistics for the IP Address with the highest retransmissioned ratio

    .EXAMPLE
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -InvalidConnections
    #Get TCP-Statistics TCP Server with invalid connections

    .EXAMPLE
    (Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -InvalidConnections -SortByInvalidConnections invalidconnections -Reverse -Page 0 -Count 3).displayedItems
    #Get TCP-Statistics for the IP Address with the highest Invalid connections

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'Handshake')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [Parameter(ParameterSetName = 'Handshake')]
        [ValidateSet('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')]
        [string]
        $SortByHandshake = 'ip',

        [Parameter(ParameterSetName = 'Retransmissions')]
        [ValidateSet('ip', 'txpayload', 'txretrans', 'txratio', 'rxpayload', 'rxretrans', 'rxratio')]
        [string]
        $SortByRetransmissions = 'ip',

        [Parameter(ParameterSetName = 'InvalidConnections')]
        [ValidateSet('ip', 'invalidfactortcp', 'invalidconnections', 'validconnections')]
        [string]
        $SortByInvalidConnections = 'ip',

        [Parameter(ParameterSetName = 'Handshake')]
        [Parameter(ParameterSetName = 'Retransmissions')]
        [Parameter(ParameterSetName = 'InvalidConnections')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'Handshake')]
        [switch]
        $History,

        [Parameter(ParameterSetName = 'InvalidConnections')]
        [switch]
        $Dosview,

        [Parameter(ParameterSetName = 'Retransmissions')]
        [switch]
        $Retransmissions,

        [Parameter(ParameterSetName = 'InvalidConnections')]
        [switch]
        $InvalidConnections,

        [int]
        $Page = 0,

        [int]
        $Count = 10,

        [int]
        $Timespan = 60,

        [Parameter(ParameterSetName = 'InvalidConnections')]
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
        $BaseURL = ('https://{0}/API/stats/modules/ip' -f $HostName)
        $HistoryString = Get-MultimeterSwitchString -Value $History
        $DosviewString = Get-MultimeterSwitchString -Value $Dosview
        switch ($PsCmdlet.ParameterSetName)
        {
            Handshake
            {
                $SessionURL = ('{0}/ipsTCP?sort={1}&reverse={2}&page={3}&count={4}&skiphistorydata={5}&timespan={6}' -f $BaseURL,
                    $SortByHandshake, $ReverseString, $Page, $Count, $HistoryString, $Timespan)
            }
            Retransmissions
            {
                $SessionURL = ('{0}/ipsTCPData?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                    $SortByRetransmissions, $ReverseString, $Page, $Count, $Timespan)
            }
            InvalidConnections
            {
                $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&values={5}&dosview={6}&timespan={7}' -f $BaseURL,
                    $SortByInvalidConnections, $ReverseString, $Page, $Count, $Values, $DosviewString , $Timespan)
            }
        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}