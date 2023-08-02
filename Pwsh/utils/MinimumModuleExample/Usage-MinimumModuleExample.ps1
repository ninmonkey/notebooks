## Step1: Generate the *.psd1, like:
$newModuleManifestSplat = @{
    Path              = './Mintils/Mintils.psd1'
    RootModule        = 'Mintils.psm1'
    Author            = 'Jake Bolton <jake.bolton.314@gmail.com>'
    Copyright         = '2023'
    ModuleVersion     = '0.0.1'
    FunctionsToExport = @(
        'Test-IsBlank'
    )
    # AliasesToExport   = 'AliasA', 'AliasB'
    Description       = 'misc utility functions'
}
New-ModuleManifest @newModuleManifestSplat -PassThru

# Multiple Ways to Import
Write-Host 'Note: Importing Module is cached by default, so if you''re making any changes, use -Force.
I only use it once in the code below, to prevent reloading 3 times

If you want to load the module in your profile, the best path to use is this profile

    $PROFILE.CurrentUserAllHosts

Because the others like "$PROFILE.CurrentUserCurrentHost" will change filepath
depending on which host you are on

Host means which shell host, like  VSCode, windowsterminal, etc...
It is **not a networking host**
' -back darkgreen

## Step2: Importing:

# 1] You can use the module name itself, if it's in $Env:PSModulePath
#   for the example location: c:\Pwsh\utils\Mintils\Mintils.psm1
#   You would add the parent directory  'c:\Pwsh\utils' to your $env:PSModulePath

# 2] You can use the name of the containing folder
Import-Module './Mintils' -Force -PassThru

# 3] Full path to a '.psm1'
Import-Module '.\Mintils\Mintils.psm1' -Force -PassThru

# list commands
Get-Command -m Mintils | Format-Table -AutoSize

Test-IsBlank ''                 # true
Test-IsBlank '' -TestIsTrueNull # false
Test-IsBlank "`n"               # true
Test-IsBlank "hi world`n"       # false
Test-IsBlank $DoesNotExist      # true
