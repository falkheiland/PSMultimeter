function Get-MultimeterDisk
{
    <#
    .SYNOPSIS
    Get Disks of the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Disks of the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterDisk -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get disks from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterDisk -Hostname 'allegro-mm-6cb3').where{$_.transport -eq 'usb'}
    #Get disks from Allegro Multimeter that are connected via USB

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
        $BaseURL = ('https://{0}/API/system/disks' -f $HostName)
        $SessionURL = ('{0}' -f $BaseURL)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}