function Get-MultimeterDnsStatistic
{
    <#
    .SYNOPSIS
    Get DNS Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get DNS Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Details
    Details ('full')

    .PARAMETER SortBy
    Property to sort by ('requests', 'ip', 'name', 'dns_server')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER DNSServer
    Switch to get DNS servers

    .PARAMETER GRT
    Switch to get Global response times

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
    Get-MultimeterDnsStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get DNS information from DNS-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterDnsStatistic -Hostname 'allegro-mm-6cb3' -SortBy 'ip' -Page 0 -Count 20 -Timespan 3600).displayedItems.name
    #Get DNS-names of the first 20 IP Addresses for the last 1 hour

    .EXAMPLE
    Get-MultimeterDnsStatistic -Hostname 'allegro-mm-6cb3' -DNSServer
    #Get DNS Server information

    .EXAMPLE
    Get-MultimeterDnsStatistic -Hostname 'allegro-mm-6cb3' -GRT
    #Get DNS Global response times

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'IPs')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [Parameter(ParameterSetName = 'GRT')]
        [Parameter(ParameterSetName = 'DNSServer')]
        [ValidateSet('full')]
        [string]
        $Details = 'full',

        [Parameter(ParameterSetName = 'GRT')]
        [Parameter(ParameterSetName = 'DNSServer')]
        [Parameter(ParameterSetName = 'IPs')]
        [ValidateSet('requests', 'ip', 'name', 'dns_server')]
        [string]
        $SortBy = 'requests',

        [Parameter(ParameterSetName = 'GRT')]
        [Parameter(ParameterSetName = 'DNSServer')]
        [Parameter(ParameterSetName = 'IPs')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'DNSServer')]
        [switch]
        $DNSServer,

        [Parameter(ParameterSetName = 'GRT')]
        [switch]
        $GRT,

        [Parameter(ParameterSetName = 'IPs')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'IPs')]
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
        $BaseURL = ('https://{0}/API/stats/modules/dns' -f $HostName)
        switch ($PsCmdlet.ParameterSetName)
        {
            IPs
            {
                $SessionURL = ('{0}/ips_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
            }
            DNSServer
            {
                $SessionURL = ('{0}/servers_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
            }
            GRT
            {
                $SessionURL = ('{0}?detail={1}&timespan={2}&values={3}' -f $BaseURL, $Details, $Timespan, $Values)
            }
        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}