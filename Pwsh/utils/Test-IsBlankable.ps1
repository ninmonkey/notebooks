
function isBlank {
    <#
    .SYNOPSIS
        Many ways to compare blank-ish items
    .DESCRIPTION
        Normal is a boolean, -PassThru returns lots of information
    .EXAMPLE
        Pwsh> $samples = @(
            ''
            $Null
            , ''
            # '   '
            "`n`n"
            "`n`n."
            ' '
        )
        $samples | ForEach-Object { "Blank?: {1} test '{0}'" -f @(
                $_ | Format-ControlChar #| Join-String -op 'Input: '
                isBlank $_
            )
        }
        $samples | ForEach-Object {
            isBlank $_ -PassThru
        } | Ft -auto

    #>
    [OutputType('System.Boolean', 'PSObject')]
    param(

        [Object]$InputObject,
        [switch]$PassThru
    )
    $strAfterStrip = $InputObject -replace '\s+', ''

    $dbg = [pscustomobject]@{
        PSTypeName = 'IsblankResult.debug.util'
        isBlankish = $isBlankLike
        trueNull             = $null -eq $InputObject
        trueEmptyStr         = [string]::Empty -eq $InputObject
        onlyWhitespace       = [String]::IsNullOrWhiteSpace( $InputObject )
        emptyOrNull          = [String]::IsNullOrEmpty( $InputObject )
        textAfterStrip       = '"{0}"' -f $strAfterStrip
        charLengthAfterStrip = $strAfterStrip.Length
        codepointsAfterStrip = $strAfterStrip.EnumerateRunes().Count
        isCollection = $InputObject.count -gt 1 # some scalars seem to return 1 or 0
    }
    $isBlankLike = $dbg.trueNull -or $dbg.truemptyStr -or $dbg.onlyWhitespace -or $dbg.emptyOrNull
    $dbg.isBlankIsh = $isBlankLike

    if ($PassThru) { return $dbg }
    return $isBlankLike
}


