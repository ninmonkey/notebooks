Function tryIter {
    [CmdletBinding()] param()
    # write-verbose -verbose 'hi'
    Write-Information 'world' -infa Continue
}
if($false) {
    tryIter *>&1 -Verbose | %{
        $color = switch( $_ ) {
            { $_ -is [InformationRecord] } { 'red'    }
            { $_ -is [VerboseRecord] }     { 'yellow' }
            default { 'purple' }
        }
        $_ | New-text -fg $color
    } | Join-string
}

function fakeIC {
    [CmdletBinding()]
    param()
    $Verby = [VerboseRecord]::new('something verbosy')
    $verby.PipelineIterationInfo
    $source = 'JBTransport'
    $data = @{
        OriginalVerboseRecord = $verby
        user = @{ name = 'jen' ; id = 24; }
        species = 'cat'
        Source = $Source
    }
    [string[]]$tags = @('RedirectedVerbose')

    $ir = [InformationRecord]::new( $data, $source )
    $ir.Tags.AddRange( $tags )

    # $PSCmdlet.WriteVerbose( $verby.Message )
    $PsCMdlet.WriteInformation(<# messageData: #> $data, <# tags: #> $tags )
    $PsCMdlet.WriteInformation( $ir )
}
    # $ir = [InformationRecord]::new( @{
    #         OriginalVerboseRecord = $verby
    #         user = @{ name = 'jen' ; id = 24; }
    #         species = 'cat'
    #     },

# fakeIc

fakeIC *>&1 -Verbose -infa 'Continue' | %{
    if(-not $_) { return }
    $color = switch( $_ ) {
        { $_ -is [InformationRecord] } {
            $_.MessageData.OriginalVerboseRecord.GetType() | out-host
            $_.MessageData | out-host
            $_.MessageData.OriginalVerboseRecord|json | out-host

            'red' # put a breakpoint here
        }
        { $_ -is [VerboseRecord] }     { 'yellow' }
        default { 'purple' }
    }
    $_ | New-text -fg $color
} | Join-string
