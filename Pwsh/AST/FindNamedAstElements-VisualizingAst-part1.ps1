using namespace System.Collections.Generic
using namespace System.Management.Automation.Language
using namespace System.Management.Automation
using namespace System.Management
err -clear
$TargetScript = gi 'H:\data\2023\pwsh\PsModules\CacheMeIfYouCan\tryPublish.ps1'
$contents = gc -raw $TargetScript

function GetAstFrom {
    <#
    .notes
    related:
        - https://gist.github.com/SeeminglyScience/4d0d63ab56b4f121b98652e831af7219
        - <https://github.com/SeeminglyScience/dotfiles/blob/bc31aaaec30343be4788d47b2c08b40d6763268d/Documents/PowerShell/Utility.psm1#L6026-L6027>

    see:
        https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser.parseinput?view=powershellsdk-7.4.0#system-management-automation-language-parser-parseinput(system-string-system-string-system-management-automation-language-token()@-system-management-automation-language-parseerror()@)
        https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser?view=powershellsdk-7.4.0
    #>
    param(
        [ValidateNotNullOrWhiteSpace()]
        [string]$FileName
    )
    if( -not (Test-Path $FileName)) {
        throw "InvalidFilepath: '$FileName'"
    }

    $Tokens = $null
    $AstErrors = $Null
    $DocRoot = [Parser]::ParseFile(
        <# fileName: #> $fileName,
        <# tokens  : #> [ref] $tokens,
        <# errors  : #> [ref] $AstErrors )

    [pscustomobject]@{
        Tokens =  $Tokens
        Errors = $AstErrors
        Fullname = $filename
        Ast = $DocRoot
    }

    if( $AstErrors.count -gt 0 ) {
        'warning, {0} Errors' -f @( $AstErrors.count )
            | write-verbose -verbose
    }
}

function QuickAstInfo {
    param(
        [Alias('Ast', 'InObj')]
        [ScriptBlockAst]$InputObject
    )
    $Config = @{
        SkipOriginal = $true
    }
    $InAst = $InputObject
    $info = @{}
    $info.OriginalAst = $InputObject
    $info.UsingStatements = $InAst.UsingStatements.Name.Value

    if( $Config.SkipOriginal) {  $info.Remove('OriginalAst') }
    return $info
}
$doc = GetAstFrom -FileName $TargetScript
hr
$doc | iot2 -NotSkipMost
hr -fg 'blue'
$doc.Ast | iot2 -NotSkipMost
$Ast = $Doc.Ast
hr -FG ORANGE

(QuickAstInfo (GetAstFrom $TargetScript).AST)
    | OutNull

$ast_end = $ast.EndBlock

( $typesFound = $ast_end.Statements | %{ $_.GetType() } | Group | % Name |sort )
$typesFound |Ft -auto
hr

label 'Name' 'Children types under of Depth 0'
( $typesFound = $ast_end.Statements | %{ $_.GetType().Name } | Group | % Name | sort-object )
   | Join.ul
hr
# $ast_end.Statements | %{
#    $_.GetType().Name
#    $_.Name
#    hr
# }

# $ast_end.Statements | %{
#    $x = $_.GetType().Name
#    $y = $_.Name
#    $rend = Label $y $x -sep ' '
#    $rend.PadLeft(80, ' ')
# }
$ast_end.Statements | %{
   $x = $_.GetType().Name
   $y = $_.Name
   $rend = Label $x $y -sep ' ' -ForegroundColor 'gray30'
   $rend # $rend.PadLeft(80, ' ')
}
$ast_end.Statements | %{
   $x = $_.GetType().Name
   $y = $_.Name
   $rend = Label $x $y -sep ' ' -ForegroundColor 'gray30'
   $rend.PadLeft(80, ' ')
}
# $maxLen = $ast_end.Statements.Name | % Length | Measure-Object -Maximum | % Maximum

hr
$pairs = $ast_end.Statements | %{
   [pscustomobject]@{
      y = $_.GetType().Name
      x = $_.Name
   }
} | %{
  $_.y = ($_.y ?? '').PadRight(30, ' ')
  $_.x = ($_.x ?? '').PadRight(30, ' ')
  $_ }
# $pairs
#   | %{ Label $_.x $_.y }
# $pairs
#   | %{ Label $_.x $_.y  -TextForegroundColor 'gray80' }


$pairs = $ast_end.Statements | %{
   [pscustomobject]@{
      y = $_.GetType().Name
      x = $_.Name
   }
} | %{
  #$_.y = ($_.y ?? '').PadRight(20, ' ')
  $_.x = ($_.x ?? '').PadRight(30, ' ')
  $_ }

function PairsFrom.Statements {
    [CmdletBinding()]
    param(
        [Alias('Statements')]
        [Parameter(ValueFromPipelineByPropertyName)]
        # [StatementAst[]]
        [object[]]
        $InAst
    ) process {
        $InAst | % GetType | join-string -op '-Proc ' | write-verbose
        if( -not $InAst ) { return }
        [pscustomobject]@{
            Name = $InAst.Name
            Kind = ($InAst)?.GetType().Name
        }
    }
}
# $doc.Ast.EndBlock | PairsFrom.Statements

# function PairsFrom.Statements {
#     param(
#         [Alias('Statements')]
#         [Parameter(ValueFromPipelineByPropertyName)]
#         [ScriptBlockAst[]]
#         # [StatementAst[]]
#         $InAst
#     )

#     $pairs = $InAst.Statements | %{
#         [pscustomobject]@{
#             y = $_.GetType().Name
#             x = $_.Name
#         }
#     } | %{
#         #$_.y = ($_.y ?? '').PadRight(20, ' ')
#         $_.x = ($_.x ?? '').PadRight(30, ' ')
#         $_
#    }
#    return $pairs
# }
function Fmt.Quick.AlignedColumns {
    param(
        $InputObject,
        [string]$Property = 'Name'
    )
    $max_left  = $InputObject | %{ $_.GetType().Name.Length } | measure -Maximum | % Maximum
    $max_right = $InputObject | %{ $_.$Property.Length } | measure -Maximum | % Maximum

    $InputObject | %{
        $Left  = $_.GetType().name
        $Right = $_.$Property
        $Left = $Left.padLeft( $max_left, ' ' )
        $Render = Label $Left $Right -sep ' ' -fore 'gray30'
        return $Render
    }
}
function Fmt2 {
    param( $InputAst )
    $max_x = $InputAst.Statements | %{ $_.GetType().Name.Length } | measure -Maximum | % Maximum

    $ast_end.Statements | %{
        $x = $_.GetType().Name
        $y = $_.Name
        $x = $x.PadLeft($max_x, ' ')
        $rend = Label $x $y -sep ' ' -ForegroundColor 'gray30'
        $rend # $rend.PadLeft(80, ' ')
    }
}


function Fmt0 {
    param( $pairs )
    $pairs   | %{ Label $_.x $_.y  -TextForegroundColor 'gray30' -sep ' '}
}


hr
$ast_end.Statements | %{
   [pscustomobject]@{
      x = $_.GetType().Name
      y = $_.Name
   }
} | %{ Label $_.x $_.y }

$ast_end.Statements | %{
   [pscustomobject]@{
      y = $_.GetType().Name
      x = $_.Name
   }
} | %{ $_.x = ($_.x ?? '').PadLeft(30, ' ') ; $_}
  | %{ Label $_.x $_.y }


Dotils.QuickFmt.TinfoCols $root.Statements

$query = $root.FindAll(
        {
            Param( [Ast]$Ast )
            end {
                if($Ast -isNot [CommandAst]) { return $false }
                if ($Ast.Extent.StartOffset -ne $extent.StartOffset -or $Ast.Extent.EndOffset -ne $extent.EndOffset) {
                        return $false
                }
                return $True
            }
        }
    , $false )
$query = $root.FindAll({ param( [Ast]$Ast ) end { return $true }}, $false ) | CountOf 'depth1'
dotils.quickFmt.TinfoCols $query
$query_all = $root.FindAll({ param( [Ast]$Ast ) end { return $true }}, $true ) | CountOf '_all'
$query_named = $query_all.Where( {$_.Name } ) | CountOf 'query_named'

dotils.quickFmt.TinfoCols $query_named
# dotils.quickFmt.TinfoCols $query_all

& {
    return
    $root.FindAll(
        {
            Param( [Ast]$Ast )
            end {
                if($Ast -isNot [CommandAst]) { return $false }
                if ($Ast.Extent.StartOffset -ne $extent.StartOffset -or $Ast.Extent.EndOffset -ne $extent.EndOffset) {
                        return $false
                }
                return $True
            }
        }
    , $true )
}


return
$targetScript
function Example_GetPreviousCommand {
    param([InvocationInfo] $InvocationInfo)

    $InvocationInfo = $InvocationInfo
    $property = $InvocationInfo.
        GetType().
        GetProperty('ScriptPosition', [Reflection.BindingFlags]::NonPublic -bor 'Public, Instance')

    [IScriptExtent] $extent = $property.GetValue($InvocationInfo)
    $containingDocument = [Parser]::ParseInput(
        $extent.StartScriptPosition.GetFullScript(),
        $extent.File,
        [ref] $null,
        [ref] $null)

    [CommandAst] $foundAst = $containingDocument.Find(
        {
            param([Ast] $Ast)
            end {
                if ($Ast -isnot [CommandAst]) {
                    return $false
                }

                if ($Ast.Extent.StartOffset -ne $extent.StartOffset -or $Ast.Extent.EndOffset -ne $extent.EndOffset) {
                    return $false
                }

                return $true
            }
        },
        $true)

    if ($null -eq $foundAst) {
        throw 'Could not find matching AST'
    }

    $pipelineElements = $foundAst.Parent.PipelineElements
    for ($i = 0; $i -lt $pipelineElements.Count; $i++) {
        if ($pipelineElements[$i] -eq $foundAst) {
            break
        }
    }

    if ($i -eq $pipelineElements.Count) {
        throw 'Cannot tell where the command is in the parent pipeline AST'
    }

    if ($i -eq 0) {
        throw 'This command cannot be the first pipeline element'
    }

    return $pipelineElements[$i - 1]
}
