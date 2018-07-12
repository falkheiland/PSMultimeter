function Get-MultimeterSystemState
{
    <#
    .SYNOPSIS
    Get System Status from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get System Status from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterSystemState -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get system state from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterSystemState -Hostname 'allegro-mm-6cb3').systemHealth.temperature
    #Get temperature of the Allegro Multimeter in degree celsius

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
        $BaseURL = ('https://{0}/API/system/state' -f $HostName)
        $SessionURL = ('{0}' -f $BaseURL)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}