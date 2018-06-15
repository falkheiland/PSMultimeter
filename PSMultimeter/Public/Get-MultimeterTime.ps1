function Get-MultimeterTime
{
    <#
    .SYNOPSIS 
    Get current time of the Allegro Multimeter via RESTAPI.
    
    .DESCRIPTION
    Get current time of the Allegro Multimeter via RESTAPI.
    
    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter
    
    .PARAMETER Credential
    Credentials for the Allegro Multimeter
    
    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterTime -Hostname 'allegro-mm-6cb2' -Credential $Credential
    #Asks for credentail then gets time from Allegro Multimeter using provided credential

    .EXAMPLE
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds([math]::Round(((Get-MultimeterTime -Hostname 'allegro-mm-6cb2').currentTime)/1000)))
    #Gets time from Allegro Multimeter and converts it to .net Time

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'IPAddresses')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,
    
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials')
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
        
        $SessionURL = ('https://{0}/API/stats/time' -f $HostName)

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