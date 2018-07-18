function Get-MultimeterInterface
{
    <#
    .SYNOPSIS
    Get interface statistics of the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get interface statistics of the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterInterface -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get interface statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    ((Get-MultimeterInterface -Hostname 'allegro-mm-6cb3').interfaces).where{$_.linkDetected -eq 'True'}
    #Get interface statistics from Allegro Multimeter for interfaces that are connected

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
        $Values = 30
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/stats/interfaces' -f $HostName)
        $SessionURL = ('{0}?timespan={1}&values={2}' -f $BaseURL, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}