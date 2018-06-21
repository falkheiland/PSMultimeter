function Get-MultimeterMacProtocol
{
    <#
    .SYNOPSIS 
    Get MAC protocols of the Allegro Multimeter via RESTAPI.
    
    .DESCRIPTION
    Get MAC protocols of the Allegro Multimeter via RESTAPI.
    
    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter
    
    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER MACAddress
    MAC-Address to get statistics for

    .PARAMETER SortBy
    Property to sort by ('protocol', bps', 'pps', 'bytes' or 'packets')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER Protocols
    Switch to get statistics for Protocols

    .PARAMETER Page
    Pagenumber

    .PARAMETER Count
    Number of Items per Page

    .PARAMETER Timespan
    Timespan

    .PARAMETER Values
    Values
    
    .EXAMPLE
    $Credential = Get-Credential -Message 'Enter your credentials'
    Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb3' -Credential $Credential
    #Asks for credentail then gets MAC protocols from Allegro Multimeter using provided credential
    
    .EXAMPLE
    (Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb3').globalCounters.allTime
    #Gets all Time counters for MAC protocols
    
    .EXAMPLE
    Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb3' -Protocols
    #Gets MAC protocols

    .EXAMPLE
    Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb3' -Protocols 
    #Gets MAC protocols

    .NOTES
    n.a.

    #>

    [CmdletBinding(DefaultParameterSetName = 'Overview')]
    param (
        [Parameter(Mandatory)]
        [string]
        $HostName,
    
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential -Message 'Enter your credentials'),
        
        [string]
        [Parameter(ParameterSetName = 'MACProtocols')]
        [ValidateSet('protocol', 'bps', 'pps', 'bytes', 'packets')]
        $SortBy = 'protocol',

        [Parameter(ParameterSetName = 'MACProtocols')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'MACProtocols')]
        [switch]
        $Protocols,

        [Parameter(ParameterSetName = 'MACProtocols')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'MACProtocols')]
        [int]
        $Count = 5,

        [int]
        $Timespan = 60,

        [Parameter(ParameterSetName = 'MACProtocols')]
        [int]
        $Values = 50
    )
    
    begin
    {
        #Trust self-signed certificates
        Add-Type -AssemblyName Microsoft.PowerShell.Commands.Utility
        if (!('TrustAllCertsPolicy' -as [type]))
        {
            Add-Type -TypeDefinition @'
            using System.Net;
            using System.Security.Cryptography.X509Certificates;
            public class TrustAllCertsPolicy : ICertificatePolicy {
                public bool CheckValidationResult(
                    ServicePoint srvPoint, X509Certificate certificate,
                    WebRequest request, int certificateProblem) {
                        return true;
                    }
                }
'@
        }

    }
    process
    {   
        #Trust self-signed certificates
        [Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
        
        $BaseURL = ('https://{0}/API/stats/modules/mac_protocols' -f $HostName)

        switch ($Reverse)
        {
            $true
            {
                $ReverseString = 'true'
            }
            $false
            {
                $ReverseString = 'false'
            }
        }
    
        switch ($PsCmdlet.ParameterSetName)
        {
            Overview
            {  
                $SessionURL = ('{0}/generic?timespan={1}' -f $BaseURL, $Timespan)
            }

            MACProtocols
            {
                $SessionURL = ('{0}/mac_protocols_paged?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}&values={6}' -f $BaseURL, 
                    $SortBy, $ReverseString, $Page, $Count, $Timespan, $Values)
            }
        }

        $Username = $Credential.UserName
        $Password = $Credential.GetNetworkCredential().Password
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Username, $Password)))

        $Params = @{
            Uri         = $SessionURL
            Headers     = @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
            ContentType = 'application/json; charset=utf-8'
            Method      = 'Get'
        }
        Invoke-RestMethod @Params
    }
    end
    {
    }
}