function Get-MultimeterMacProtocolOverview
{
    <#
    .SYNOPSIS
    Get Overview from MAC Protocols from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Overview from MAC Protocols from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Timespan
    Timespan

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterMacProtocolOverview -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Overview from MAC Protocols from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterMacProtocolOverview -Hostname 'allegro-mm-6cb3').globalCounters.allTime
    #Get all Time counters for MAC protocols

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
        $BaseURL = ('https://{0}/API/stats/modules/mac_protocols' -f $HostName)
        $SessionURL = ('{0}/generic?timespan={1}' -f $BaseURL, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}