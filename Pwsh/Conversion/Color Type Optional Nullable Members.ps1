Import-Module Pansies

<#
try:
    $pestStub = gi -ea stop 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-2023.5.0\modules\PowerShellEditorServices\InvokePesterStub.ps1'
    $target   = gi -ea stop 'h:\data\2023\pwsh\notebooks\Pwsh\Conversion\Color Type Optional Nullable Members.tests.ps'
    . $PestStub -ScriptPath $PestTarget -All -MinimumVersion5 -Output 'FromPreference'#>


# throw "Wi: never finished '$PSCommandPath' of '$PSScriptRoot'"

class ColorRGBA {
    <#
    .NOTES
        see also:
            pansies and $PSStyle
    hacky structure layout as a quick sample
        some thing
    .LINK
        https://github.com/PoshCode/Pansies/blob/main/Source/Assembly/RgbColor.cs
    .LINK
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_ansi_terminals?view=powershell-7.4
    #>

    [Int]$Red
    [Int]$Green
    [Int]$Blue
    [Nullable[Int]]$Alpha
    hidden [ValidateNotNullOrEmpty()][string]$rawRgbString

    static [object] ParseRgbHexString ( [string]$HexString ) {
        if ( [ColorRGBA]::RegexHexString -match $HexString ) {
            $matches.remove(0)
            $matches.PSTypeName = 'ColorRgba.ParsedHexString'
            return [PSCustomObject]$matches
        }
        throw "InvalidRgbaHexStringException: Could not parse: '$HexString'"
    }

    static [bool] IsValidRgbHexString( [string]$HexString ) {
        $clean = $HexString -replace [Regex]::Escape('\#'), ''

        if ($clean.Length -notin (6, 8)) {
            'Could not parse Input "{0}"! Length {1} ≠ 6 or 8 !' -f @(
                $clean
                $clean.Length
            ) | Write-Error
            return $false
        }
        if ($clean -match '[^a-fA-F0-9]+') {
            'Could not parse Input "{0}"! Length {1} ≠ 6 or 8 !' -f @(
                $clean
                $clean.Length
            ) | Write-Error
            return $false
        }
        return $true
    }
    static [string] $RegexHexString = @'
(?xi)
    \#?
    (?<HexString>
        (?<Hex6>
            (?<Red>[0-9a-fA-F]{2})
            (?<Green>[0-9a-fA-F]{2})
            (?<Blue>[0-9a-fA-F]{2})
            (?<Alpha>[0-9a-fA-F]{2})?
        )
    )
'@

    ColorRGBA ( [string]$RgbHexString ) {
        $this.rawRgbString = $RgbHexString -replace '\#', ''

        if ( -not [ColorRGBA]::IsValidRgbHexString( $this.rawRgbString ) ) {
            $ex = 'Invalid RgbHexString {0}' -f @( Join-String -inp $this.rawRgbString -SingleQuote )
            throw $ex
        }
        $This.Red = 0
        $This.Green = 0
        $This.Blue = 0
    }
    [bool] HasAlphaComponent() {
        return -not ($null -eq $this.A)
    }

    [object] AsExcelRgbColor() {
        throw 'nyi, code in other repo'
    }
    # [object] maybe soft-dependency with Object,but lets go static
    [PoshCode.Pansies.RgbColor] AsPansiesRgbColor() {
        # ToPansiesRgb ?
        try {
            return [RgbColor]::new( $this.rawRgbString )
        }
        catch {
            try {
                return [RgbColor]::new( $this.Red, $this.Blue, $this.Green )
            }
            catch {
                'ShouldNeverReachException: both [rgbcolor] c-tor''s failed: {0} : {1}' -f @( $PSCommandPath, $_ ) | Write-Error
            }
        }
        return $null
    }

    [string] ToString() {
        return '<ColorRgba {HexString: {0}, HasAlpha: {1} }>' -f @(
            $this.HasAlphaComponent()

        )
    }
}

$colorType = @{
    TypeName    = 'ColorRGBA'
    ErrorAction = 'continue' #'ignore'
    Force       = $true
    Verbose     = $True
}

Update-TypeData @colorType -MemberType 'AliasProperty' -MemberName 'ToPansies' -Value 'AsPansiesRgbColor' # not sure whether alias to a method is valid, maybe codepmethod?

Update-TypeData @colorType -MemberType 'ScriptProperty' -MemberName 'HasAlpha' -Value {
    return (-not ($null -eq $this.Alpha))
}




# #ff0000
# ( 6bit vs

# 88c0d0

# ```ps1
# [Int]$Red
# [Nullable[Int]]$Alpha
# [bool] HasAlphaComponent() {
#     return -not ($null -eq $this.A)
# }
# ```
