function Get-MultimeterReverseString
{
    <#
    .SYNOPSIS
    Translate Reverse Parameter to String

    .DESCRIPTION
    Translate Reverse Parameter to String

    .EXAMPLE
    $ReverseString = Get-MultimeterReverseString -Reverse $Reverse

    .NOTES
     n.a.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Reverse
    )

    begin
    {
    }
    process
    {
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
        $ReverseString
    }
    end
    {
    }
}