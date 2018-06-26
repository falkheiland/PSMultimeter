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

    (Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -Retransmissions -SortByRetransmissions txratio -Reverse -Page 0 -Count 1).displayedItems
    #Get TCP-Statistics for the IP Address with the highest retransmissioned ratio



    .EXAMPLE
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Overview
    #Get overview of TCP-Statistics for IP Address '192.168.0.1'

    .EXAMPLE
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Protocols
    #Get TCP-Statistics for Protocols for IP Address '192.168.0.1'

    .EXAMPLE
    (Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Timespan 60 -Protocols).protocols.Youtube.bytesFrom
    #Get Bytes received from for Protocol Youtube for IP Address '192.168.0.1' during the last 60 seconds

    .EXAMPLE
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Peers
    #Get TCP-Statistics for Peers for IP Address '192.168.0.1'

    .EXAMPLE
    $Peer = (Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Peers -SortBy Bytes -Reverse -Count 1).displayedItems
    'http://maps.google.com/?ll={0},{1}' -f ($Peer.latitude -replace(',','.')), ($Peer.longitude -replace(',','.'))
    #Get the Peer for IP Address '192.168.0.1' with te most Bytes used and converts its Geolocation to Google Maps URL

    .EXAMPLE
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Connections
    #Get TCP-Statistics for Connections for IP Address '192.168.0.1'

    .EXAMPLE
    (Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Connections -SortBy Bytes -Reverse -Page 3 -Count 1).displayedItems.server.dnsName
    #Get DNS Name of the Server with the 3rd most Connections to IP Address '192.168.0.1'

    .EXAMPLE
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Ports
    #Get TCP-Statistics for Ports for IP Address '192.168.0.1'

    .EXAMPLE
    Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -Global
    #Get Global TCP-Statistics

    .EXAMPLE
    $Stats = (Get-MultimeterTcpStatistic -Hostname 'allegro-mm-6cb3' -Global).tcpStats
    'Retransmissions: {0}%' -f [math]::Round(($Stats.globalRetransmissionBytes*100/$Stats.globalTotalBytes),3)
    #Get Retransmissions in Percent from Global TCP-Statistics

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
        #Trust self-signed certificates
        Add-Type -AssemblyName Microsoft.PowerShell.Commands.Utility
        if (!('TrustAllCertsPolicy' -as [type]))
        {
            Add-Type -TypeDefinition @'
            using System.Net;
            using System.Security.Cryptography.X509Certificates;
            public class TrustAllCertsPolicy : ICertificatePolicy {
                public bool CheckValidationResult(
                    ServicePoint srvPoint, X509Certificate certificate,
                    WebRequest request, int certificateProblem) {
                        return true;
                    }
                }
'@
        }
    }
    process
    {
        #Trust self-signed certificates
        [Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy

        $BaseURL = ('https://{0}/API/stats/modules/ip' -f $HostName)

        switch ($Reverse)
        {
            $true
            {
                $ReverseString = 'true'
            }
            $false
            {
                $ReverseString = 'false'
            }
        }
        switch ($History)
        {
            $true
            {
                $HistoryString = 'true'
            }
            $false
            {
                $HistoryString = 'false'
            }
        }
        switch ($Dosview)
        {
            $true
            {
                $DosviewString = 'true'
            }
            $false
            {
                $DosviewString = 'false'
            }
        }

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

        $Username = $Credential.UserName
        $Password = $Credential.GetNetworkCredential().Password
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Username, $Password)))

        $Params = @{
            Uri         = $SessionURL
            Headers     = @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
            ContentType = 'application/json; charset=utf-8'
            Method      = 'Get'
        }
        Invoke-RestMethod @Params
    }
    end
    {
    }
}