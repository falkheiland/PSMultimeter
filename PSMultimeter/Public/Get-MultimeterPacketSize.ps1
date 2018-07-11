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
    Get-MultimeterPacketSize -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get packet size (distribution) from Allegro Multimeter using provided credential

    .EXAMPLE
    ((Get-MultimeterPacketSize -Hostname 'allegro-mm-6cb3').globalCounters.allTime)[6]
    #Get all time packet count from Allegro Multimeter for packet size 1519-1522 bytes

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
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/stats/modules/packet_size' -f $HostName)
        $SessionURL = ('{0}/generic?timespan={1}' -f $BaseURL, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}