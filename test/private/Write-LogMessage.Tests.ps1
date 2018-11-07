#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    InModuleScope $module {
        Context 'When conditions are normal' {
            It "Executes successfully when verbose" {
                { Write-LogMessage -Message 'Event' -Type Verbose } | Should not throw
            }

            It "Executes successfully when output" {
                { Write-LogMessage -Message 'Event' -Type Output } | Should not throw
            }
        }
    }
}

AfterFeature
