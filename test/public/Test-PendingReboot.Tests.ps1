#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    InModuleScope $module {
        Context 'When conditions are normal' {
            Mock Invoke-Command { $false }

            It 'Executes successfully' {
                { Test-PendingReboot } | Should not throw
            }
        }
    }
}

AfterFeature
