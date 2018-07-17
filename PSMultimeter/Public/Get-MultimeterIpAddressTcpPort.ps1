function Get-MultimeterIpAddressTcpPort
{
    <#
    .SYNOPSIS
    Get open TCP server ports for IP Address from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get open TCP server ports for IP Address from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER IPAddress
    Ip-Address to get statistics for

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterIpAddressTcpPort -Hostname 'allegro-mm-6cb3' -IPAddress '10.11.11.1' -Credential $Credential
    #Ask for credential then get open TCP server ports for IP Address from Allegro Multimeter using provided credential

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

        [Parameter(Mandatory)]
        [ValidateScript( {$_ -match [IPAddress]$_})]
        [string]
        $IPAddress,

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
        $BaseURL = ('https://{0}/API/stats/modules/ip' -f $HostName)
        $SessionURL = ('{0}/ips/{1}/ports?timespan={2}&values={3}' -f $BaseURL, $IPAddress, $Timespan, $Values)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}