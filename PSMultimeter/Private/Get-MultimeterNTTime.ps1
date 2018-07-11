function Get-MultimeterNTTime
{
    <#
    .SYNOPSIS
    Get NT Time  from Multimeter Time

    .DESCRIPTION
    Get NT Time  from Multimeter Time

    .EXAMPLE
    Get-MultimeterNTTime -Time '1531315866280,7749'

    .NOTES
     n.a.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Time
    )

    begin
    {
    }
    process
    {
        [datetime]$NTTime = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds([math]::Round(($Time.Replace(',', '.')) / 1000)))
        $NTTime
    }
    end
    {
    }
}