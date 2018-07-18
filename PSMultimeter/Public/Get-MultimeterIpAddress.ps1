function Get-MultimeterIpAddress
{
    <#
    .SYNOPSIS
    Get IP addresses from IP statistics from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get IP addresses from IP statistics from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('bps', 'pps', 'bytes', 'packets')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER Location
    ContryCode for Locationfilter (e.g. 'DE')

    .PARAMETER Page
    Pagenumber

    .PARAMETER Count
    Number of Items per Page

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterIpAddress -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get IP addresses from IP statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    Get-MultimeterIpAddress -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
    #Get IP-Statistics for the IP Address with the most Bytes in the last 1 hour

    .EXAMPLE
    Get-MultimeterIpAddress -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Page 0 -Count 1 -Reverse -Location 'DE'
    #Get IP-Statistics for the IP Address with the most Bytes in the last 1 hour from Location Germany

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

        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        [string]
        $SortBy = 'bytes',

        [switch]
        $Reverse,

        [string]
        $Location = 'na',

        [int]
        $Page = 0,

        [int]
        $Count = 10,

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
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/ip' -f $HostName)
        switch ($Location)
        {
            'na'
            {
                $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            Default
            {
                $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&countryfilter={5}&timespan={6}&values={7}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Location, $Timespan, $Values)
            }
        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}