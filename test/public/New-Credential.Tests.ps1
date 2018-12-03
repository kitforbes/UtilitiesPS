#requires -modules Pester
. $PSScriptRoot\..\Shared.ps1
$function = Get-TestFileName -Path $MyInvocation.MyCommand.Path

BeforeFeature

Describe $function -Tags ('unit') {
    InModuleScope $module {
        Context 'When conditions are normal' {
            Mock Write-LogMessage {}
            Mock New-Object {}

            It 'Executes successfully with a secure password' {
                $secureString = ConvertTo-SecureString -String 'Password' -AsPlainText -Force
                { New-Credential -UserName 'User' -Password $secureString } | Should not throw
            }

            It 'Executes successfully with an insecure password' {
                { New-Credential -UserName 'User' -InsecurePassword 'Password' } | Should not throw
            }
        }
    }
}

AfterFeature
