
function .CallStack {
    # function Bdg.Render.CallStack {
    [CmdletBinding()]
    param(
        [ValidateSet('Default', 'Line', 'Table', 'CustomObject', 'List', 'Yaml', 'PassThru')]
        [string]$OutputFormat = 'Default',

        # input else current
        [Parameter(mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('CallStack', 'Frames', 'Stack', 'CallStackFrame', 'Command')]
        [Management.Automation.CallStackFrame[]]$InputObject,

        [switch]$ExtraVerbose
    )
    begin {
        # [Collections.Generic.List[Object]]$Items = @()
        [Collections.Generic.List[Management.Automation.CallStackFrame]]$Items = @()
        if ($ExtraVerbose) {
            '-begin Cmdlet.Expect? {0}, MyInvoC.Expect?: {1}, Key?: [ -InpObj: {2}, -Frames: {3} ]' -f @(
                $PSCmdlet.MyInvocation.ExpectingInput
                $MyInvocation.ExpectingInput
                $PSBoundParameters.ContainsKey('InputObject')
                $PSBoundParameters.ContainsKey('Frames')
            ) | Write-Host -fore white -back darkblue
        }
    }
    process {
        if ($ExtraVerbose) {
            '-proc  Cmdlet.Expect? {0}, MyInvoC.Expect?: {1}, Key?: [ -InpObj: {2}, -Frames: {3} ]' -f @(
                $PSCmdlet.MyInvocation.ExpectingInput
                $MyInvocation.ExpectingInput
                $PSBoundParameters.ContainsKey('InputObject')
                $PSBoundParameters.ContainsKey('Frames')
            ) | Write-Host -fore white -back darkblue
        }
        # if pipeline expecting input, merge list of items
    }
    end {
        if ($ExtraVerbose) {
            '-end   Cmdlet.Expect? {0}, MyInvoC.Expect?: {1}, Key?: [ -InpObj: {2}, -Frames: {3} ]' -f @(
                $PSCmdlet.MyInvocation.ExpectingInput
                $MyInvocation.ExpectingInput
                $PSBoundParameters.ContainsKey('InputObject')
                $PSBoundParameters.ContainsKey('Frames')
            ) | Write-Host -fore white -back darkblue
        }

        if ( -not $MyInvocation.ExpectingInput -or -not $items) {
            $items = Get-PSCallStack
        }

        # if(-not $PSBoundParameters.)
        [string[]]$render = ''
        switch ($OutputFormat) {
            'Default' {
                $render = $Items | Join-String -Property Command -sep ' ▸ '
            }
            'Line' {
                $render = $Items | Join-String -Property Command -sep ' Ⳇ '
            }
            'List' {
                $render = $Items | Join-String -Property Command -f "`n - {0}"
            }

            default {
                throw "UnhandledOutputFormat: $OutputFormat"
                # 'sdfds'
            }
        }
        $sbRaw = "${bg:gray40}${fg:gray70}{Sb}${bg:clear}${fg:clear}"
        $sbRaw = '{Sb}'
        $render -join "`n" -replace [Regex]::Escape('<ScriptBlock>'), $sbRaw

    }
}

@'
--------------------------------------------------------------------------------------------
## example output:
--------------------------------------------------------------------------------------------
    $pstack = Get-PSCallStack
    $pstack | .CallStack
--------------------------------------------------------------------------------------------

-begin Cmdlet.Expect? True, MyInvoC.Expect?: True, Key?: [ -InpObj: False, -Frames: False ]
-proc  Cmdlet.Expect? True, MyInvoC.Expect?: True, Key?: [ -InpObj: True,  -Frames: False ]
-end   Cmdlet.Expect? True, MyInvoC.Expect?: True, Key?: [ -InpObj: True,  -Frames: False ]

--------------------------------------------------------------------------------------------
    $pstack = Get-PSCallStack
    .CallStack -InputObject $pstack
--------------------------------------------------------------------------------------------
-begin Cmdlet.Expect? False, MyInvoC.Expect?: False, Key?: [ -InpObj: True, -Frames: False ]
-proc  Cmdlet.Expect? False, MyInvoC.Expect?: False, Key?: [ -InpObj: True, -Frames: False ]
-end   Cmdlet.Expect? False, MyInvoC.Expect?: False, Key?: [ -InpObj: True, -Frames: False ]
--------------------------------------------------------------------------------------------
'@ | out-null

Hr

$pstack = Get-PSCallStack
$pstack | .CallStack List
Hr
$pstack = Get-PSCallStack
.CallStack -InputObject $pstack
hr
$pstack = Get-PSCallStack
$pstack | .CallStack 'List'
$pstack | .CallStack 'Default'
$pstack | .CallStack 'Line'