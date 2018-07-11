function Get-MultimeterTime
{
    <#
    .SYNOPSIS
    Get current time of the Allegro Multimeter via RESTAPI.

    .DESCRIPTION
    Get current time of the Allegro Multimeter via RESTAPI.

    .PARAMETER HostName
    Ip-Address or Hostname of the Allegro Multimeter

    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER DateTime
    Switch to get .NET Time (DateTime-Format)

    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterTime -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Ask for credential then get time from Allegro Multimeter using provided credential

    .EXAMPLE
    Get-MultimeterTime -Hostname 'allegro-mm-6cb3' -DateTime
    #Get time from Allegro Multimeter and convert it to .NET Time (DateTime-Format)

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
        $BaseURL = ('https://{0}/API/stats/time' -f $HostName)
        $SessionURL = ('{0}' -f $BaseURL)
        $MultimeterTime = Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'
        switch ($DateTime)
        {
            $false
            {
                $MultimeterTime.currentTime
            }
            $true
            {
                Get-MultimeterNTTime -Time $MultimeterTime.currentTime
            }
        }
    }
    end
    {
    }
}