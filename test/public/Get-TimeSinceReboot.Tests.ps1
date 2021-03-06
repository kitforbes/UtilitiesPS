#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    Context 'When conditions are normal' {
        It 'Executes successfully' {
            { Get-TimeSinceReboot } | Should not throw
        }
    }
}

AfterFeature
