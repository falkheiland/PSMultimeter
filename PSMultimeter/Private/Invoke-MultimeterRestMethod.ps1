function Invoke-MultimeterRestMethod
{
    <#
    .SYNOPSIS
    Invoke-RestMethod Wrapper for Multimeter API

    .DESCRIPTION
    Invoke-RestMethod Wrapper for Multimeter API

    .EXAMPLE
    Invoke-MultimeterRestMethod -Credential $Credential -SessionURL $SessionURL -Method 'Get'

    .NOTES
     n.a.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(Mandatory)]
        [string]
        $SessionURL,

        [Parameter(Mandatory)]
        [ValidateSet('Get', 'Post', 'Put', 'Delete')]
        [string]
        $Method
    )

    begin
    {
    }
    process
    {
        $Username = $Credential.UserName
        $Password = $Credential.GetNetworkCredential().Password
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Username, $Password)))

        $Params = @{
            Uri         = $SessionURL
            Headers     = @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
            ContentType = 'application/json; charset=utf-8'
            Method      = $Method
        }
        Invoke-RestMethod @Params
    }
    end
    {
    }
}