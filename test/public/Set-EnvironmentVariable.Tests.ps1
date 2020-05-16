#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    Context 'When setting an environment variable' {
        It 'Executes successfully' {
            { Set-EnvironmentVariable -Name 'SECRET' -Value 'Sauce' } | Should not throw
        }
    }
}

AfterFeature
