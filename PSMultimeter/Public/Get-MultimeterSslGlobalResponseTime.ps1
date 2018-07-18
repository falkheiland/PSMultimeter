function Get-MultimeterSslGlobalResponseTime
{
    <#
    .SYNOPSIS
    Get SSL response times from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get SSL response times from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Details
    Details ('full')

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterSslGlobalResponseTime -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get SSL response timesfrom Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterSslGlobalResponseTime -Hostname 'allegro-mm-6cb3').globalHelloResponseTimes.avg
    #Get average SSL Global Response Time for SSL-Hello-handshakes in ms

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

        [ValidateSet('full')]
        [string]
        $Details = 'full',

        [int]
        $Timespan = 60,

        [int]
        $Values = 60
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/stats/modules/ssl' -f $HostName)
        $SessionURL = ('{0}?detail={1}&timespan={2}&values={3}' -f $BaseURL, $Details, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}