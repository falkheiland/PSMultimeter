function Get-MultimeterTcpRetransmission
{
    <#
    .SYNOPSIS
    Get Global TCP retransmissions from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Global TCP retransmissions from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('ip', 'txpayload', 'txretrans', 'txratio', 'rxpayload', 'rxretrans', 'rxratio')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER Page
    Pagenumber

    .PARAMETER Count
    Number of Items per Page

    .PARAMETER Timespan
    Timespan

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterTcpRetransmission -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Global TCP retransmissions from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterTcpRetransmission -Hostname 'allegro-mm-6cb3' -SortBy txratio -Reverse -Page 0 -Count 1).displayedItems
    #Get TCP-Statistics for the IP Address with the highest retransmissioned ratio

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

        [ValidateSet('ip', 'txpayload', 'txretrans', 'txratio', 'rxpayload', 'rxretrans', 'rxratio')]
        [string]
        $SortBy = 'ip',

        [switch]
        $Reverse,

        [int]
        $Page = 0,

        [int]
        $Count = 10,

        [int]
        $Timespan = 60
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/ip' -f $HostName)
        $SessionURL = ('{0}/ipsTCPData?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}