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
    Get-MultimeterIpStatistics -Hostname '10.11.11.35' | Select-Object -First 1
    Gets all IP-Address for the Host with most bytes send /received

    .EXAMPLE
    ((Get-MultimeterIpStatistics -Hostname '10.11.11.35' | Select-Object -First 1).displayedItems).ip
    Gets all IP-Address for the Host with most bytes send /received

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

        [switch]
        $Reverse,

        [int]
        $Count = 10
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

        if ($Reverse)
        {
            $ReverseString = 'true'
        }
        else
        {
            $ReverseString = 'false'
        }

        $SessionURL = ('https://{0}/API/stats/modules/ip/ips_paged?sort=bps&reverse={1}&page=0&count={2}' -f $HostName, $ReverseString, $Count)
    }

    process
    {   
        #Trust self-signed certificates
        [Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
        
        $Username = $Credential.UserName
        $Password = $Credential.GetNetworkCredential().Password
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Username, $Password)))

        $Params = @{
            Uri         = $SessionURL
            Headers     = @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
            ContentType = 'application/json; charset=utf-8'
            Method      = 'Get'
        }
        (Invoke-RestMethod @Params).displayedItems
    }
    
    end
    {
    }
}