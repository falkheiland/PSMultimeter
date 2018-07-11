function Get-MultimeterNotification
{
    <#
    .SYNOPSIS
    Get notifications of the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get notifications of the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterNotification -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get notifications from Allegro Multimeter using provided credential

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

        [switch]
        $DateTime
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/system/notifications' -f $HostName)
        $SessionURL = ('{0}' -f $BaseURL)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}