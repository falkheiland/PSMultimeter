function Get-MultimeterVlanStatistic
{
    <#
    .SYNOPSIS
    Get Vlan Statistics for the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Vlan Statistics for the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('bps', 'pps', 'bytes' or 'packets')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER VLANQinQ
    Switch to get statistics for VLANQinQ

    .PARAMETER Vlan
    Vlan to get statistics for, -1 equals 'no VLAN'

    .PARAMETER OuterVlan
    Outer Vlan to get statistics for, -1 equals 'no VLAN'

    .PARAMETER InnerVlan
    Inner Vlan to get statistics for, -1 equals 'no VLAN'

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
    Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Vlan-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    (((Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600).displayedItems).where{$_.outerVlanTag -eq -1}).bytes
    #Get Vlan-Statistics for the last 1 hour and shows bytes for VLAN 1

    .EXAMPLE
    Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -VLANQinQ
    #Get VLAN Q-inQ statistics

    .EXAMPLE
    Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -Vlan 111
    #Get statistics for outer VLAN '111'

    .EXAMPLE
    Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -OuterVlan 111 -InnerVlan -1
    #Get statistics for outer VLAN '111', no inner VLAN (-1)

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'OuterVLAN')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),

        [string]
        [Parameter(ParameterSetName = 'OuterVLAN')]
        [Parameter(ParameterSetName = 'VLANQinQ')]
        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        $SortBy = 'bytes',

        [Parameter(ParameterSetName = 'OuterVLAN')]
        [Parameter(ParameterSetName = 'VLANQinQ')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'VLANQinQ')]
        [switch]
        $VLANQinQ,

        [Parameter(ParameterSetName = 'VLAN')]
        [ValidateRange(-1, 4096)]
        [int]
        $Vlan,

        [Parameter(ParameterSetName = 'OIVLAN')]
        [ValidateRange(-1, 4096)]
        [int]
        $OuterVlan,

        [Parameter(ParameterSetName = 'OIVLAN')]
        [ValidateRange(-1, 4096)]
        [int]
        $InnerVlan,

        [Parameter(ParameterSetName = 'OuterVLAN')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'VLANQinQ')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'OuterVLAN')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'VLANQinQ')]
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
        $BaseURL = ('https://{0}/API/stats/modules/vlan' -f $HostName)
        switch ($PsCmdlet.ParameterSetName)
        {
            OuterVLAN
            {
                $SessionURL = ('{0}/vlans_paged?sort={1}&reverse={2}&page={3}&count={4}&values={5}&timespan={6}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Values, $Timespan)
            }
            VLANQinQ
            {
                $SessionURL = ('{0}/inner_vlans_paged?sort={1}&reverse={2}&page={3}&count={4}&values={5}&timespan={6}' -f $BaseURL,
                    $SortBy, $ReverseString, $Page, $Count, $Values, $Timespan)
            }
            VLAN
            {
                $SessionURL = ('{0}/vlans/{1}?timespan={2}' -f $BaseURL,
                    $Vlan, $Timespan)
            }
            OIVLAN
            {
                $SessionURL = ('{0}/vlans/{1}_{2}?timespan={3}' -f $BaseURL,
                    $OuterVlan, $InnerVlan, $Timespan)
            }
        }
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}