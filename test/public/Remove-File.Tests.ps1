#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    InModuleScope $module {
        Context 'When removing a file that exists' {
            Mock Write-LogMessage {}
            Mock Test-Path { $true }
            Mock Remove-Item {}

            $testPath = "TestDrive:\test.txt"
            # Set-Content -Path $testPath -Value "test"

            It 'Executes successfully' {
                { Remove-File -Path $testPath } | Should not throw
            }
        }

        Context 'When removing a file that does not exist' {
            Mock Write-LogMessage {}
            Mock Test-Path { $false }
            Mock Remove-Item {}

            $testPath = "TestDrive:\test.txt"
            # Set-Content -Path $testPath -Value "test"

            It 'Executes successfully' {
                { Remove-File -Path $testPath } | Should not throw
            }
        }
    }
}

AfterFeature
