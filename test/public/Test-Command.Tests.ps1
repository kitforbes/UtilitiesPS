#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    Context 'When conditions are normal' {
        It 'Executes successfully' {
            { Test-Command -Name 'New-Item' } | Should not throw
        }
    }

    Context 'When the command can be found' {
        It 'Returns true' {
            { Test-Command -Name 'New-Item' } | Should not throw
            Test-Command -Name 'New-Item' | Should -BeTrue
        }
    }

    Context 'When the command cannot be found' {
        It 'Returns false' {
            { Test-Command -Name 'Fake-Command' } | Should not throw
            Test-Command -Name 'Fake-Command' | Should -BeFalse
        }
    }
}

AfterFeature
