#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    InModuleScope $module {
        Context 'When conditions are normal' {
            Mock Write-LogMessage {}

            New-Item -Path "TestDrive:\dir1\dir2" -ItemType Directory -Force
            Set-Content -Path "TestDrive:\dir1\dir2\test2.txt" -Value "test"
            Set-Content -Path "TestDrive:\dir1\test1.txt" -Value "test"

            It 'Executes successfully' {
                { Measure-Directory -Path "TestDrive:\dir1" } | Should not throw
            }
        }
    }
}

AfterFeature
