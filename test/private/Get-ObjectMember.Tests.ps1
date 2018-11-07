#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    InModuleScope $module {
        Context 'When conditions are normal' {
            Mock Write-LogMessage {}

            It "Executes successfully with valid JSON" {
                $obj = '{"a":{"b":"c"}}' | ConvertFrom-Json
                { Get-ObjectMember -Object $obj } | Should not throw
            }
        }
    }
}

AfterFeature
