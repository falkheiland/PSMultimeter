function Invoke-MultimeterTrustSelfSignedCertificate
{
    <#
    .SYNOPSIS
    Trust self-signed certificates

    .DESCRIPTION
    Trust self-signed certificates

    .EXAMPLE
    Invoke-MultimeterTrustSelfSignedCertificate

    .NOTES
     n.a.
    #>

    [CmdletBinding()]
    param (

    )

    begin
    {
    }
    process
    {
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
        [Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
    }
    end
    {
    }
}