function Get-MultimeterL4PortTcpOverview
{
    <#
    .SYNOPSIS
    Get Statistics for TCP Server Port from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Statistics for TCP Server Port from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Port
    TCP Port to get statistics for

    .PARAMETER Timespan
    Timespan

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterL4PortTcpOverview -Hostname 'allegro-mm-6cb3' -Port 443 -Credential $Credential
    #Ask for credential then Statistics for TCP Server Port 443 from Allegro Multimeter using provided credential

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

        [ValidateRange(1, 65535)]
        [int]
        $Port,

        [int]
        $Timespan = 60
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/stats/modules/l4_ports' -f $HostName)
        $SessionURL = ('{0}/tcp_port/{1}?timespan={2}' -f $BaseURL, $Port, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}