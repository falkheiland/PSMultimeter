function Get-MultimeterVlanOverview
{
    <#
    .SYNOPSIS
    Get Statistics for outer VLAN from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Statistics for outer VLAN from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Vlan
    Vlan to get statistics for, -1 equals 'no VLAN'

    .PARAMETER Timespan
    Timespan

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterVlanOverview -Hostname 'allegro-mm-6cb3' -Vlan 1111 -Credential $Credential
    #Ask for credential then get Statistics for outer VLAN 1111 from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterVlanOverview -Hostname 'allegro-mm-6cb3').displayedItems
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
        $Vlan,

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
        $SessionURL = ('{0}/vlans/{1}?timespan={2}' -f $BaseURL,
            $Vlan, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}