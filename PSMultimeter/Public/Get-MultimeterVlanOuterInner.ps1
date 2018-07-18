function Get-MultimeterVlanOuterInner
{
    <#
    .SYNOPSIS
    Get Statistics for outer VLAN, no inner VLAN from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Statistics for outer VLAN, no inner VLAN from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER OuterVlan
    Outer Vlan to get statistics for, -1 equals 'no VLAN'

    .PARAMETER InnerVlan
    Inner Vlan to get statistics for, -1 equals 'no VLAN'

    .PARAMETER Timespan
    Timespan

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterVlanOuterInner -Hostname 'allegro-mm-6cb3' -OuterVlan 1111 -InnerVlan -1 -Credential $Credential
    #Ask for credential then get Statistics for outer VLAN '1111', no inner VLAN from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterVlanOuterInner -Hostname 'allegro-mm-6cb3').displayedItems
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

        [ValidateRange(-1, 4096)]
        [int]
        $OuterVlan,

        [ValidateRange(-1, 4096)]
        [int]
        $InnerVlan,

        [int]
        $Timespan = 60
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/stats/modules/vlan' -f $HostName)
        $SessionURL = ('{0}/vlans/{1}_{2}?timespan={3}' -f $BaseURL,
            $OuterVlan, $InnerVlan, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}