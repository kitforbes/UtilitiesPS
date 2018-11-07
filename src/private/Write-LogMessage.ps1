function Write-LogMessage {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [String]
        $Message,
        # Parameter help description
        [Parameter(Mandatory = $false)]
        [ValidateSet('Verbose', 'Output')]
        [String]
        $Type = 'Verbose'
    )

    begin {
    }

    process {
        $text = "$(Get-Date -UFormat "%Y/%m/%d %T"): $(((Get-PSCallStack).Command)[1]): $Message"
        switch ($Type) {
            Output {
                Write-Output -InputObject $text
            }
            Verbose {
                Write-Verbose -Message $text
            }
        }
    }

    end {
    }
}
