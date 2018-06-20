function Get-MultimeterPacketSize
{
    <#
    .SYNOPSIS 
    Get packet size (distribution) of the Allegro Multimeter via RESTAPI.
    
    .DESCRIPTION
    Get packet size (distribution) of the Allegro Multimeter via RESTAPI.
    
    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter
    
    .PARAMETER Credential
    Credentials for the Allegro Multimeter
    
    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterPacketSize -Hostname 'allegro-mm-6cb2' -Credential $Credential
    #Asks for credentail then gets packet size (distribution) from Allegro Multimeter using provided credential

    .EXAMPLE
    ((Get-MultimeterPacketSize -Hostname 'allegro-mm-6cb2').globalCounters.allTime)[6]
    #Gets all time packet count from Allegro Multimeter for packet size 1519-1522 bytes

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

        [int]
        $Timespan = 60
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
        
        $SessionURL = ('https://{0}/API/stats/modules/packet_size/generic?timespan={1}' -f $HostName, $Timespan)

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