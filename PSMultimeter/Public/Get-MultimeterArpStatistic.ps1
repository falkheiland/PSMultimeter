function Get-MultimeterArpStatistic
{
    <#
    .SYNOPSIS
    Get Arp Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Arp Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('bps', 'pps', 'bytes' or 'packets')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER MACInformation
    Switch to get MACInformation

    .PARAMETER IPInformation
    Switch to get IPInformation

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
    Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Arp-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600
    #Get Arp-Statistics for the last 1 hour

    .EXAMPLE
    Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -MACInformation
    #Get ARP MAC information

    .EXAMPLE
    (Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -MACInformation -SortBy bytes -Reverse -Page 0 -Count 1 -Timespan 60).displayedItems.mac
    #Get MAC Address for the Host with most bytes in the last hour

    .EXAMPLE
    Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -IPInformation
    #Get ARP MAC information

    .EXAMPLE
    (Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -IPInformation -SortBy bytes -Reverse -Page 0 -Count 1 -Timespan 60).displayedItems.ip
    #Get IP Address for the Host with most bytes in the last hour

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'Overview')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [string]
        [Parameter(ParameterSetName = 'Overview')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'IPInformation')]
        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        $SortBy = 'bytes',

        [Parameter(ParameterSetName = 'Overview')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'IPInformation')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'MACInformation')]
        [switch]
        $MACInformation,

        [Parameter(ParameterSetName = 'IPInformation')]
        [switch]
        $IPInformation,

        [Parameter(ParameterSetName = 'Overview')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'IPInformation')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'Overview')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'IPInformation')]
        [int]
        $Count = 5,

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
        #$ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/arp' -f $HostName)
        switch ($PsCmdlet.ParameterSetName)
        {
            Overview
            {
                $SessionURL = ('{0}?&timespan={1}&values={2}' -f $BaseURL, $Timespan, $Values)
            }
            MACInformation
            {
                $SessionURL = ('{0}/macs?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
            }
            IPInformation
            {
                $SessionURL = ('{0}/ips?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
            }
        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}