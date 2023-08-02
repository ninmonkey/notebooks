# Multiple Ways to Import
Write-Host 'Note: Importing Module is cached by default, so if you''re making any changes, use -Force'

# 1] You can use the module name itself, if it's in $Env:PSModulePath
# example location: c:\Pwsh\utils\Mintils\Mintils.psm1
Import-Module -Force -PassThru -Name 'Mintils'

# 2] You can use the name of the containing folder
Import-Module -path './Mintils'

# 3] Full path to a '.psm1'
Import-Module -path './Mintils/Mintils.psm1'

## Step1: Generate the *.psd1, like:
$newModuleManifestSplat = @{
    Path              = 'Mintils.psd1'
    RootModule        = 'Mintils.ps1'
    Author            = 'Jake Bolton <jake.bolton.314@gmail.com>'
    Copyright         = '2023'
    ModuleVersion     = '0.0.1'
    FunctionsToExport = 'funcA', 'funcB'
    AliasesToExport   = 'AliasA', 'AliasB'
    Description       = 'misc utility functions'
}

# New-ModuleManifest @newModuleManifestSplat

# list commands
Get-Command -m Mintils | Format-Table -AutoSize

Test-IsBlank ''                 # true
Test-IsBlank '' -TestIsTrueNull # false
Test-IsBlank "`n"               # true
Test-IsBlank "hi world`n"       # false
Test-IsBlank $DoesNotExist      # true
