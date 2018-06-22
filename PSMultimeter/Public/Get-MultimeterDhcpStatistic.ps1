function Get-MultimeterDhcpStatistic
{
    <#
    .SYNOPSIS
    Get DHCP Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get DHCP Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Details
    Details ('full')

    .PARAMETER SortBy
    Property to sort by ('issueTime', 'ip', 'name', 'mac')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER DHCPServer
    Switch to get DHCP servers

    .PARAMETER GRT
    Swicth to get Global response times

    .PARAMETER MessageTypes
    Switch to get DHCP message types

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
    Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get DHCP information from DHCP-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -SortBy 'ip' -Page 0 -Count 20 -Timespan 3600).displayedItems.hostName
    #Get Hostnames of the first 20 IP Addresses for the last 1 hour

    .EXAMPLE
    Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -DHCPServer
    #Get DHCP Server information

    .EXAMPLE
    Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -GRT
    #Get DHCP Global response times

    .EXAMPLE
    Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -MessageTypes
    #Get DHCP message types

    .EXAMPLE
    (((Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -MessageTypes).where{$_.name -eq 'request'}) |
        Select-Object -Property Count).count
    #Get number of DHCP messages of type 'request'

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'Overview')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [Parameter(ParameterSetName = 'GRT')]
        [Parameter(ParameterSetName = 'MessageTypes')]
        [Parameter(ParameterSetName = 'DHCPServer')]
        [ValidateSet('full')]
        [string]
        $Details = 'full',

        [Parameter(ParameterSetName = 'GRT')]
        [Parameter(ParameterSetName = 'MessageTypes')]
        [Parameter(ParameterSetName = 'DHCPServer')]
        [Parameter(ParameterSetName = 'Overview')]
        [ValidateSet('issueTime', 'ip', 'name', 'mac')]
        [string]
        $SortBy = 'issueTime',

        [Parameter(ParameterSetName = 'GRT')]
        [Parameter(ParameterSetName = 'MessageTypes')]
        [Parameter(ParameterSetName = 'DHCPServer')]
        [Parameter(ParameterSetName = 'Overview')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'DHCPServer')]
        [switch]
        $DHCPServer,

        [Parameter(ParameterSetName = 'GRT')]
        [switch]
        $GRT,

        [Parameter(ParameterSetName = 'MessageTypes')]
        [switch]
        $MessageTypes,

        [Parameter(ParameterSetName = 'Overview')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'Overview')]
        [int]
        $Count = 10,

        [int]
        $Timespan = 60,

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

        $BaseURL = ('https://{0}/API/stats/modules/dhcp' -f $HostName)

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
            Overview
            {
                $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
                #Overview
                #DHCP information
                #https://allegro-mm-6cb3/API/stats/modules/dhcp/ips_paged?sort=issueTime&reverse=true&page=0&count=10&timespan=60
            }
            DHCPServer
            {
                $SessionURL = ('{0}/servers?detail={1}&timespan={2}&values={3}' -f $BaseURL, $Details, $Timespan, $Values)
                #DHCP Server
                #https://allegro-mm-6cb3/API/stats/modules/dhcp/servers?detail=full&timespan=60&values=60
            }
            GRT
            {
                $SessionURL = ('{0}?detail={1}&timespan={2}&values={3}' -f $BaseURL, $Details, $Timespan, $Values)
                #Global response times and MessageTypes
                #https://allegro-mm-6cb3/API/stats/modules/dhcp?detail=full&timespan=60&values=60
            }
            MessageTypes
            {
                $SessionURL = ('{0}?detail={1}&timespan={2}&values={3}' -f $BaseURL, $Details, $Timespan, $Values)
                #Global response times and MessageTypes
                #https://allegro-mm-6cb3/API/stats/modules/dhcp?detail=full&timespan=60&values=60
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
        switch ($PsCmdlet.ParameterSetName)
        {
            GRT
            {
                (Invoke-RestMethod @Params).globalResponseTimes
            }
            MessageTypes
            {
                (Invoke-RestMethod @Params).messageTypes
            }
            Default
            {
                Invoke-RestMethod @Params
            }
        }
    }
    end
    {
    }
}