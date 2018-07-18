function Get-MultimeterSslTop
{
    <#
    .SYNOPSIS
    Get Most accessed SSL servers from the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get Most accessed SSL servers from the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    IP-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER Page
    Pagenumber

    .PARAMETER Count
    Number of Items per Page

    .PARAMETER Timespan
    Timespan

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterSslTop -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get Most accessed SSL servers from Allegro Multimeter using provided credential

    .EXAMPLE
    (Get-MultimeterSslTop -Hostname 'allegro-mm-6cb3' -Page 0 -Count 3).displayedItems.ip
    #Get IP Address of the 3 most used SSL Server

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

        [int]
        $Page = 0,

        [int]
        $Count = 10,

        [int]
        $Timespan = 60
    )

    begin
    {
    }
    process
    {
        Invoke-MultimeterTrustSelfSignedCertificate
        $BaseURL = ('https://{0}/API/stats/modules/ssl' -f $HostName)
        $SessionURL = ('{0}/top-ssl?page={1}&count={2}&timespan={3}' -f $BaseURL, $Page, $Count, $Timespan)
        Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
    }
    end
    {
    }
}