function Get-MultimeterArpStatistic
{
    <#
    .SYNOPSIS 
    Get Arp Statistics for the Allegro Multimeter via RESTAPI.
    
    .DESCRIPTION
    Get Arp Statistics for the Allegro Multimeter via RESTAPI.
    
    .PARAMETER HostName
    Ip-Address or Hostname  of the Allegro Multimeter
    
    .PARAMETER Credential
    Credentials for the Allegro Multimeter

    .PARAMETER SortBy
    Property to sort by ('bps', 'pps', 'bytes' or 'packets')

    .PARAMETER Reverse
    Switch, Sort Order, Default Ascending, with Parameter Descending

    .PARAMETER MACInformation
    Switch to get statistics for MACInformation

    .PARAMETER IPInformation
    Switch to get statistics for IPInformation

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
    Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -Credential $Credential
    #Asks for credential then gets Arp-Statistics from Allegro Multimeter using provided credential

    .EXAMPLE
    Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -Timespan 3600
    #Gets Arp-Statistics for the last 1 hour

    .EXAMPLE
    Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -MACInformation
    #Gets ARP MAC information

    .EXAMPLE
    (Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -MACInformation -SortBy bytes -Reverse -Page 0 -Count 1 -Timespan 60).displayedItems.mac
    #Gets MAC Address for the Host with most bytes in the last hour

    .EXAMPLE
    Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -IPInformation
    #Gets ARP MAC information

    .EXAMPLE
    (Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -IPInformation -SortBy bytes -Reverse -Page 0 -Count 1 -Timespan 60).displayedItems.ip
    #Gets IP Address for the Host with most bytes in the last hour

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
        [Parameter(ParameterSetName = 'Overview')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'IPInformation')]
        [ValidateSet('bps', 'pps', 'bytes', 'packets')]
        $SortBy = 'bytes',

        [Parameter(ParameterSetName = 'Overview')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'IPInformation')]
        [switch]
        $Reverse,

        [Parameter(ParameterSetName = 'MACInformation')]
        [switch]
        $MACInformation,

        [Parameter(ParameterSetName = 'IPInformation')]
        [switch]
        $IPInformation,

        [Parameter(ParameterSetName = 'Overview')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'IPInformation')]
        [int]
        $Page = 0,

        [Parameter(ParameterSetName = 'Overview')]
        [Parameter(ParameterSetName = 'MACInformation')]
        [Parameter(ParameterSetName = 'IPInformation')]
        [int]
        $Count = 5,

        [int]
        $Timespan = 60,

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
        
        $BaseURL = ('https://{0}/API/stats/modules/arp' -f $HostName)

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
                $SessionURL = ('{0}?&timespan={1}&values={2}' -f $BaseURL, $Timespan, $Values)
            }
            MACInformation
            {
                $SessionURL = ('{0}/macs?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL, 
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
            }
            IPInformation
            {
                $SessionURL = ('{0}/ips?sort={1}&reverse={2}&page={3}&count={4}&timespan={5}' -f $BaseURL, 
                    $SortBy, $ReverseString, $Page, $Count, $Timespan)
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