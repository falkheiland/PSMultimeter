function Get-MultimeterIpStatistics
{
    <#
    .SYNOPSIS 
    Get IP Statistics for the Allegro Multimeter via RESTAPI.
    
    .DESCRIPTION
    Get IP Statistics for the Allegro Multimeter via RESTAPI.
    
    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter
    
    .PARAMETER Credential
    Credentials for the Allegro Multimeter
    
    .EXAMPLE
    Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb3'
    Gets all IP-Statistics from Allegro Multimeter

    .EXAMPLE
    Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb3' -Count 1 -Reverse

    .EXAMPLE
    Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb3' -IPAddress '10.11.11.1'

    .EXAMPLE
    $Credential = (Get-Credential -Message 'Enter your credentials')
    ((Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb3' -Credential $Credential | Select-Object -First 1).displayedItems).ip

    .NOTES
    General notes
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

        [Parameter(ParameterSetName = 'IPAddress')]
        [Parameter(ParameterSetName = 'IPAddressProtocols')]
        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [Parameter(ParameterSetName = 'IPAddressPorts')]
        [ValidateScript( {$_ -match [IPAddress]$_})]
        [string]
        $IPAddress,
        
        [string]
        [Parameter(ParameterSetName = 'IPAddresses')]
        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        $SortBy = 'bytes',

        [Parameter(ParameterSetName = 'IPAddresses')]
        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'IPAddressProtocols')]
        [switch]
        $Protocols,

        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [switch]
        $Peers,

        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [switch]
        $Connections,

        [Parameter(ParameterSetName = 'IPAddressPorts')]
        [switch]
        $Ports,

        [Parameter(ParameterSetName = 'IPAddresses')]
        [Parameter(ParameterSetName = 'IPAddressProtocols')]
        [Parameter(ParameterSetName = 'IPAddressPeers')]
        [Parameter(ParameterSetName = 'IPAddressConnections')]
        [int]
        $Count = 10,

        [int]
        $Timespan = 1,

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
    
        switch ($PsCmdlet.ParameterSetName)
        {
            IPAddresses
            {  
                $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page=0&count={3}&timespan={4}&values={5}' -f $BaseURL, 
                    $SortBy, $ReverseString, $Count, $Timespan, $Values)
            }
            IPAddress
            {
                $SessionURL = ('{0}/ips/{1}?timespan={2}&values={3}' -f $BaseURL, $IPAddress, $Timespan, $Values)
            }
            IPAddressProtocols
            {
                $SessionURL = ('{0}/ips/{1}/protocols?timespan={2}&values={3}' -f $BaseURL, $IPAddress, $Timespan, $Values)
            }
            IPAddressPeers
            {
                $SessionURL = ('{0}/ips/{1}/peers?sort={2}&reverse={3}&page=0&count={4}&timespan={5}&values={6}' -f $BaseURL, 
                    $IPAddress, $SortBy, $ReverseString, $Count, $Timespan, $Values)
            }
            IPAddressConnections
            {
                $SessionURL = ('{0}/ips/{1}/connections?sort={2}&reverse={3}&page=0&count={4}&timespan={5}&values={6}' -f $BaseURL, 
                    $IPAddress, $SortBy, $ReverseString, $Count, $Timespan, $Values)
            }
            IPAddressPorts
            {
                $SessionURL = ('{0}/ips/{1}/ports?timespan={2}&values={3}' -f $BaseURL, $IPAddress, $Timespan, $Values)
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