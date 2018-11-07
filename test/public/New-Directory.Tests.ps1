#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    InModuleScope $module {
        Context 'When creating a directory that does not exist' {
            Mock Write-LogMessage {}
            Mock Test-Path { $false }
            Mock New-Item {}

            $testPath = "TestDrive:\test.txt"
            # Set-Content -Path $testPath -Value "test"

            It "Executes successfully" {
                { New-Directory -Path $testPath } | Should not throw
            }
        }

        Context 'When creating a directory that already exists' {
            Mock Write-LogMessage {}
            Mock Test-Path { $true }
            Mock New-Item {}

            $testPath = "TestDrive:\test.txt"
            # Set-Content -Path $testPath -Value "test"

            It "Executes successfully" {
                { New-Directory -Path $testPath } | Should not throw
            }
        }
    }
}

AfterFeature
