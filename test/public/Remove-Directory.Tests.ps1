#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    InModuleScope $module {
        Context 'When removing a directory that exists' {
            Mock Write-LogMessage {}
            Mock Test-Path { $true }
            Mock Remove-Item {}

            $testPath = "TestDrive:\test.txt"
            # Set-Content -Path $testPath -Value "test"

            It 'Executes successfully' {
                { Remove-Directory -Path $testPath } | Should not throw
            }
        }

        Context 'When removing a directory that does not exist' {
            Mock Write-LogMessage {}
            Mock Test-Path { $false }
            Mock Remove-Item {}

            $testPath = "TestDrive:\test.txt"
            # Set-Content -Path $testPath -Value "test"

            It 'Executes successfully' {
                { Remove-Directory -Path $testPath } | Should not throw
            }
        }
    }
}

AfterFeature
