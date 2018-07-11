function Get-MultimeterSystemInfo
{
    <#
    .SYNOPSIS
    Get System Info of the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get System Info of the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterSystemInfo -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get system info from Allegro Multimeter using provided credential

    .EXAMPLE
    [math]::Round((((Get-MultimeterSystemInfo -Hostname 'allegro-mm-6cb3').uptimeSec)/86400),2)
    #Get uptime in days from Allegro Multimeter

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
        $Credential = (Get-Credential -Message 'Enter your credentials')
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/info/system' -f $HostName)
        $SessionURL = ('{0}' -f $BaseURL)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}