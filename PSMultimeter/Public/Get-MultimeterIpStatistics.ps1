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
    Credetials for the Allegro Multimeter
    
    .EXAMPLE
    Get-MultimeterIpStatistics -Hostname '10.11.11.35'
    Gets all IP-Statistics from Allegro Multimeter

    .EXAMPLE
    Get-MultimeterIpStatistics -Hostname '10.11.11.35' -Count 1 -Reverse

    .EXAMPLE
    Get-MultimeterIpStatistics -Hostname '10.11.11.35' -IPAddress '10.11.11.1'

    .EXAMPLE
    ((Get-MultimeterIpStatistics -Hostname '10.11.11.35' | Select-Object -First 1).displayedItems).ip

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
        [ValidateScript( {$_ -match [IPAddress]$_})]
        [string]
        $IPAddress,
        
        [string]
        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        $SortBy = 'bps',

        [Parameter(ParameterSetName = 'IPAddresses')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'IPAddresses')]
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