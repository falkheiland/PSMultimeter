function Get-MultimeterMulticastStatistic
{
    <#
    .SYNOPSIS
    Get Multicast Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Multicast Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'multicastActivity', 'activity', 'numberOfClients')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER Overall
    Switch to get statistics for Overall multicast negotiations

    .PARAMETER Groups
    Switch to get statistics for Groups

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
    Get-MultimeterMulticastStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Overall multicast negotiations information from Multicast-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    Get-MultimeterMulticastStatistic -Hostname 'allegro-mm-6cb3' -Groups
    #Get Groups information from Multicast-Statistics from Allegro Multimeter

    .EXAMPLE
    (Get-MultimeterMulticastStatistic -Hostname 'allegro-mm-6cb3' -Groups -Page 0 -Count 10 -SortBy numberOfClients -Reverse).displayedItems.ip
    #Gets IP for the 10 Groups with the most Number of Clients from Multicast-Statistics from Allegro Multimeter

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'Overall')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [string]
        [Parameter(ParameterSetName = 'Groups')]
        [ValidateSet('ip', 'multicastActivity', 'activity', 'numberOfClients')]
        $SortBy = 'ip',

        [Parameter(ParameterSetName = 'Groups')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'Overall')]
        [switch]
        $Overall,

        [Parameter(ParameterSetName = 'Groups')]
        [switch]
        $Groups,

        [Parameter(ParameterSetName = 'Groups')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'Groups')]
        [int]
        $Count = 5,

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
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/multicast' -f $HostName)
        switch ($PsCmdlet.ParameterSetName)
        {
            Overall
            {
                $SessionURL = ('{0}/generic?timespan={1}&values={2}' -f $BaseURL, $Timespan, $Values)
            }
            Groups
            {
                $SessionURL = ('{0}/groups_paged?sort={1}&reverse={2}&page={3}&count={4}&values={5}&timespan={6}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Values, $Timespan)
            }
        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}