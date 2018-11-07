function Get-ObjectMember {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSCustomObject]
        $Object
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        $output = $Object | Get-Member -MemberType NoteProperty | ForEach-Object {
            $key = $_.Name
            [PSCustomObject] @{
                Key   = $key
                Value = $Object."$key"
            }
        }

        return $output
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
