function Get-MultimeterHttpStatistic
{
    <#
    .SYNOPSIS
    Get HTTP Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get HTTP Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER Server
    Switch to get statistics for HTTP Server

    .PARAMETER TopRequest
    Switch to get statistics for most used HTTP Server

    .PARAMETER GlobalResponse
    Switch to get statistics for global HTTP-Request Times

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
    Get-MultimeterHttpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get HTTP Server Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (((Get-MultimeterHttpStatistic -Hostname 'allegro-mm-6cb3' -SortBy score -Server -Count 10000 -Page 0).displayedItems).where{$_.countryCode -eq 'US'}).httpHostNames
    #Get the HTTP Host Names of the all  the HTTP Server from Contry United States

    .EXAMPLE
    Get-MultimeterHttpStatistic -Hostname 'allegro-mm-6cb3' -TopRequest
    #Get 10 most used HTTP Server

    .EXAMPLE
    (Get-MultimeterHttpStatistic -Hostname 'allegro-mm-6cb3' -TopRequest -Page 0 -Count 3).displayedItems.ip
    #Get IP Address of the 3 most used (requests) SSL Server

    .EXAMPLE
    Get-MultimeterHttpStatistic -Hostname 'allegro-mm-6cb3' -GlobalResponse
    #Get HTTP Gloabl Response Time statistics

    .EXAMPLE
    (Get-MultimeterHttpStatistic -Hostname 'allegro-mm-6cb3' -GlobalResponse).globalResponseTimes.avg
    #Get average HTTP Global Response Time in ms

    .EXAMPLE
    (Get-MultimeterHttpStatistic -Hostname 'allegro-mm-6cb3' -GlobalResponse).globalResponseCodes.code5xx
    #Get number of HTTP Global Response Code for Server Errors

    .EXAMPLE
    Get-MultimeterHttpStatistic -Hostname 'allegro-mm-6cb3' -Response
    #Get HTTP Response Time statistics

    .EXAMPLE
    (Get-MultimeterHttpStatistic -Hostname 'allegro-mm-6cb3' -Response -SortBy min -Page 0 -Count 1).displayedItems.responseTimes.score
    #Get score of the HTTP-Server with the lowest response time

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
        [Parameter(ParameterSetName = 'Response')]
        [Parameter(ParameterSetName = 'ResponseCode')]
        [ValidateSet('ip', 'requests', 'avg', 'stddev', 'min', 'max', 'score')]
        [string]
        $SortBy = 'ip',

        [Parameter(ParameterSetName = 'Server')]
        [Parameter(ParameterSetName = 'Response')]
        [Parameter(ParameterSetName = 'ResponseCode')]
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

        [Parameter(ParameterSetName = 'Server')]
        [Parameter(ParameterSetName = 'Response')]
        [Parameter(ParameterSetName = 'ResponseCode')]
        [switch]
        $Response,

        [Parameter(ParameterSetName = 'Server')]
        [Parameter(ParameterSetName = 'Response')]
        [Parameter(ParameterSetName = 'ResponseCode')]
        [Parameter(ParameterSetName = 'TopRequest')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'Server')]
        [Parameter(ParameterSetName = 'Response')]
        [Parameter(ParameterSetName = 'ResponseCode')]
        [Parameter(ParameterSetName = 'TopRequest')]
        [int]
        $Count = 10,

        [int]
        $Timespan = 60,

        [Parameter(ParameterSetName = 'Server')]
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

        $BaseURL = ('https://{0}/API/stats/modules/http' -f $HostName)

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
                $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
            }
            TopRequest
            {
                $SessionURL = ('{0}/response-stats?sort=requests&page={1}&count={2}&timespan={3}' -f $BaseURL,
                    $Page, $Count, $Timespan)
            }
            GlobalResponse
            {
                $SessionURL = ('{0}?detail=full&timespan=60&values=60' -f $BaseURL, $Timespan, $Values)
            }
            Response
            {
                $SessionURL = ('{0}/response-stats?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
            }
            ResponseCode
            {
                $SessionURL = ('{0}/codes?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
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