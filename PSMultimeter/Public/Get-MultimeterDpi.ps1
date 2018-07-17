function Get-MultimeterDpi
{
    <#
    .SYNOPSIS
    Get L7 Protocols for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get L7 Protocols for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('protocol', 'packets', 'pps', 'bytes', 'bps')

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
    Get-MultimeterDpi -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get L7 Protocol Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    $Protocol = (Get-MultimeterDpi -Hostname 'allegro-mm-6cb3' -SortBy bytes -Reverse -Count 10 -Page 0).displayedItems
    $Protocol.foreach{'Protocol: {0}  - Transfered: {1} GB' -f $_.name, [math]::Round((($_.allTime[1])/1000000000),2)}
    #Get names and Transfered GB from the Top 10 L7 Protocols by bytes

    .EXAMPLE
    ((Get-MultimeterDpi -Hostname 'allegro-mm-6cb3' -Count 10000 -Page 0).displayedItems).where{$_.name -eq 'SMB'}
    #Get L7 Protocol statistics for Protocol SMB

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

        [ValidateSet('protocol', 'packets', 'pps', 'bytes', 'bps')]
        [string]
        $SortBy = 'protocol',

        [switch]
        $Reverse,

        [int]
        $Page = 0,

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
        $ReverseString = Get-MultimeterSwitchString -Value $Reverse
        $BaseURL = ('https://{0}/API/stats/modules/dpi' -f $HostName)
        $SessionURL = ('{0}/dpi_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL,
            $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}