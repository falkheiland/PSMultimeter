function Get-MultimeterMulticastOverview
{
    <#
    .SYNOPSIS
    Get Overall multicast negotiations from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Overall multicast negotiations from the Allegro Multimeter via RESTAPI.

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
    Get-MultimeterMulticastOverview -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Overall multicast negotiations from Xxx from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterMulticastOverview -Hostname 'allegro-mm-6cb3').displayedItems
    #Get

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
        $Values = 100
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/stats/modules/multicast' -f $HostName)
        $SessionURL = ('{0}/generic?timespan={1}&values={2}' -f $BaseURL, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}