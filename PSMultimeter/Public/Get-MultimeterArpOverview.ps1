function Get-MultimeterArpOverview
{
    <#
    .SYNOPSIS
    Get ARP Statistics Overview from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get ARP Statistics Overview from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterArpOverview -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get ARP Statistics Overview from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterArpOverview -Hostname 'allegro-mm-6cb3').requests
    #Get number of ARP request

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
        $Timespan = 60,

        [int]
        $Values = 50
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/stats/modules/arp' -f $HostName)
        $SessionURL = ('{0}?&timespan={1}&values={2}' -f $BaseURL, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}