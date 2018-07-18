function Get-MultimeterDhcpGlobalResponseTime
{
    <#
    .SYNOPSIS
    Get DHCP global reponse times from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get DHCP global reponse times from the Allegro Multimeter via RESTAPI.

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
    Get-MultimeterDhcpGlobalResponseTime -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get DHCP global reponse times from Allegro Multimeter using provided credential


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
        $BaseURL = ('https://{0}/API/stats/modules/dhcp' -f $HostName)
        $SessionURL = ('{0}?detail={1}&timespan={2}&values={3}' -f $BaseURL, $Details, $Timespan, $Values)
        (Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get').globalResponseTimes
    }
    end
    {
    }
}