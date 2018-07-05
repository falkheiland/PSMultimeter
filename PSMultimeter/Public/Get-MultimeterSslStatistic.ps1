function Get-MultimeterSslStatistic
{
    <#
    .SYNOPSIS
    Get SSL Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get SSL Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER IPAddress
    IP Address to get statistics for

    .PARAMETER SortByInfo
    Property to sort by ('ip')

    .PARAMETER SortBy
    Property to sort by ('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER ServerInfo
    Switch to get statistics for SSL Server

    .PARAMETER TopRequest
    Switch to get statistics for most used SSL Server

    .PARAMETER GlobalResponse
    Switch to get statistics for global SSL-Request Times

    .PARAMETER Response
    Switch to get statistics for Responses

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
    Get-MultimeterSslStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get SSL Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (((Get-MultimeterSslStatistic -Hostname 'allegro-mm-6cb3' -Server -Count 10000 -Page 0).displayedItems).where{$_.sslHelloResponseTimes.score -eq 1}).countryName
    #Get the Names of the countries with the badest responsetime-score 'BAD'

    .EXAMPLE
    Get-MultimeterSslStatistic -Hostname 'allegro-mm-6cb3' -Server -IPAddress '54.93.67.167'
    #Get SSL Statistics for Server with IP '158.85.224.173'

    .EXAMPLE
    Get-MultimeterSslStatistic -Hostname 'allegro-mm-6cb3' -TopRequest
    #Get 10 most used SSL Server

    .EXAMPLE
    (Get-MultimeterSslStatistic -Hostname 'allegro-mm-6cb3' -TopRequest -Page 0 -Count 3).displayedItems.ip
    #Get IP Address of the 3 most used SSL Server

    .EXAMPLE
    Get-MultimeterSslStatistic -Hostname 'allegro-mm-6cb3' -GlobalResponse
    #Get SSL Gloabl Response Time statistics

    .EXAMPLE
    (Get-MultimeterSslStatistic -Hostname 'allegro-mm-6cb3' -GlobalResponse).globalHelloResponseTimes.avg
    #Get average SSL Global Response Time for SSL-Hello-handshakes in ms

    .EXAMPLE
    Get-MultimeterSslStatistic -Hostname 'allegro-mm-6cb3' -Response
    #Get SSL Response Time statistics

    .EXAMPLE
    (Get-MultimeterSslStatistic -Hostname 'allegro-mm-6cb3' -Response -SortBy min -Page 0 -Count 1).displayedItems.sslHelloResponseTimes.score
    #Get SSL-Handshake-score of the SSL-Server with the lowest response time

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'Server')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [Parameter(ParameterSetName = 'Server')]
        [ValidateScript( {$_ -match [IPAddress]$_})]
        [string]
        $IPAddress = '0.0.0.0',

        [Parameter(ParameterSetName = 'Server')]
        [Parameter(ParameterSetName = 'Response')]
        [ValidateSet('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')]
        [string]
        $SortBy = 'ip',

        [Parameter(ParameterSetName = 'Server')]
        [Parameter(ParameterSetName = 'Response')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'Server')]
        [switch]
        $Server,

        [Parameter(ParameterSetName = 'TopRequest')]
        [switch]
        $TopRequest,

        [Parameter(ParameterSetName = 'GlobalResponse')]
        [switch]
        $GlobalResponse,

        [Parameter(ParameterSetName = 'Response')]
        [switch]
        $Response,

        [Parameter(ParameterSetName = 'Server')]
        [Parameter(ParameterSetName = 'Response')]
        [Parameter(ParameterSetName = 'TopRequest')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'Server')]
        [Parameter(ParameterSetName = 'Response')]
        [Parameter(ParameterSetName = 'TopRequest')]
        [int]
        $Count = 10,

        [int]
        $Timespan = 60,

        [Parameter(ParameterSetName = 'GlobalResponse')]
        [int]
        $Values = 60
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

        $BaseURL = ('https://{0}/API/stats/modules/ssl' -f $HostName)

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

        switch ($PsCmdlet.ParameterSetName)
        {
            Server
            {
                if ($IPAddress -eq '0.0.0.0')
                {
                    $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                        $SortBy, $ReverseString, $Page, $Count, $Timespan)
                }
                else
                {
                    $SessionURL = ('{0}/ips_paged?page={1}&count={2}&filter={3}&timespan={4}' -f $BaseURL,
                        $Page, $Count, $IPAddress, $Timespan)
                }
            }
            TopRequest
            {
                $SessionURL = ('{0}/top-ssl?page={1}&count={2}&timespan={3}' -f $BaseURL, $Page, $Count, $Timespan)
            }
            GlobalResponse
            {
                $SessionURL = ('{0}?detail=full&timespan={1}&values={2}' -f $BaseURL, $Timespan, $Values)
            }
            Response
            {
                $SessionURL = ('{0}/response-stats?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
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