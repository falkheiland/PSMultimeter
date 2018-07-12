function Get-MultimeterSystemUser
{
    <#
    .SYNOPSIS
    Get local users from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get local users from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterSystemUser -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get system user from Allegro Multimeter using provided credential

    .EXAMPLE
    ((Get-MultimeterSystemUser -Hostname 'allegro-mm-6cb3').where{$_.roles -eq 'admin'}).username
    #Get username of admin users

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
        $BaseURL = ('https://{0}/API/system/users' -f $HostName)
        $SessionURL = ('{0}' -f $BaseURL)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}