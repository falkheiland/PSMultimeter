function Get-MultimeterSwitchString
{
    <#
    .SYNOPSIS
    Translate Switch Value to String

    .DESCRIPTION
    Translate Switch Value to String

    .EXAMPLE
    Get-MultimeterSwitchString -Value $true

    .NOTES
     n.a.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Value
    )

    begin
    {
    }
    process
    {
        switch ($Value)
        {
            $true
            {
                $SwitchString = 'true'
            }
            $false
            {
                $SwitchString = 'false'
            }
        }
        $SwitchString
    }
    end
    {
    }
}