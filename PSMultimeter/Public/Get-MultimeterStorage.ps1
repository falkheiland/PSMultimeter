function Get-MultimeterStorage
{
    <#
    .SYNOPSIS
    Get Storage of the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Storage of the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterStorage -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get storgae from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterStorage -Hostname 'allegro-mm-6cb3').device.isInUse
    #Get storage from Allegro Multimeter and checks if it is in use

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
        $BaseURL = ('https://{0}/API/system/storage' -f $HostName)
        $SessionURL = ('{0}' -f $BaseURL)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}