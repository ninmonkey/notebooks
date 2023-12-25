function testShortenStr {
    <#
    .NOTES
        Silly. I didn't realize -Process will *always* run even without a pipeline

    #>
    [OutputType('String')]
    [CmdletBinding()]
    param(
        # Text to format
        [Alias('Text', 'String')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [AllowEmptyString()]
        [AllowNull()]
        [string[]]$InputObject,
        [int]$maxLength = 80
    )
    begin {
        function truncateString {
            [outputType('String')]
            param( [string]$Text, [int]$maxLength )
            if($null -eq $Text -or $Text.Length -eq 0) { return '␀' }
            [int]$selectedCount = [math]::Clamp(
                <# value #> $maxLength, <# min #> 0, <# max #> $Text.Length )
            return $Text.SubString(0, $selectedCount )
        }
    }
    process {
        if($MyInvocation.ExpectingInput ) {
            foreach($item in $InputObject) {
                truncateString -Text $item -maxLength $maxLength
            }
        }
    }
    end {
        if(-not $MyInvocation.ExpectingInput ) {
            foreach($item in $InputObject) {
                truncateString -Text $item -maxLength $maxLength
            }
        }
    }
}