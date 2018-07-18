function Get-MultimeterLocationOverview
{
    <#
    .SYNOPSIS
    Get Xxx Yyy from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Xxx Yyy from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Location
    Countrycode zu search for (e.g. 'DE')

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterLocationOverview -Hostname 'allegro-mm-6cb3' -Location 'DE' -Credential $Credential
    #Ask for credential then get Yyy from Xxx from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterLocationOverview -Hostname 'allegro-mm-6cb3').displayedItems
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

        [Parameter(Mandatory)]
        [string]
        $Location,

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
        $BaseURL = ('https://{0}/API/stats/modules/location' -f $HostName)
        $SessionURL = ('{0}/country?timespan={1}&values={2}&country={3}' -f $BaseURL, $Timespan, $Values, $Location)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}