function Get-MultimeterLocationStatistic
{
    <#
    .SYNOPSIS
    Get Location Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Location Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Location
    Location to get Statistics for

    .PARAMETER SortBy
    Property to sort by ('bps', 'pps', 'bytes' or 'packets')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

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
    Get-MultimeterLocationStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Location-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterLocationStatistic -Hostname 'allegro-mm-6cb3' -SortBy bytes -Page 0 -Count 10 -Reverse).displayedItems.code
    #Get Code for the 10 Locations with most Bytes

    .EXAMPLE
    Get-MultimeterLocationStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
    #Get Location-Statistics for the Location with the most Bytes in the last 1 hour

    .EXAMPLE
    Get-MultimeterLocationStatistic -Hostname 'allegro-mm-6cb3' -Location 'DE'
    #Get overview of Location-Statistics for Location 'DE'

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'Locations')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [Parameter(ParameterSetName = 'Location')]
        [string]
        $Location,

        [string]
        [Parameter(ParameterSetName = 'Locations')]
        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        $SortBy = 'bytes',

        [Parameter(ParameterSetName = 'Locations')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'Locations')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'Locations')]
        [int]
        $Count = 5,

        [int]
        $Timespan = 1,

        [int]
        $Values = 50
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/location' -f $HostName)
        switch ($PsCmdlet.ParameterSetName)
        {
            Locations
            {
                $SessionURL = ('{0}/countries_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
            Location
            {
                $SessionURL = ('{0}/country?timespan={1}&values={2}&country={3}' -f $BaseURL, $Timespan, $Values, $Location)
            }
        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}