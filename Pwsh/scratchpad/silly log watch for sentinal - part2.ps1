Import-Module NameIt
$Path = @{
    Log1 = 'g:\temp\emo.log'
    Log2 = 'g:\temp\emo.out.log'
}
$Conf = @{
    OnlyValidOutput =$false
    LogDelayMs = 1400
    # Info = $false
    Info = $false
}
$PSDefaultParameterValues.remove('*:verbose')

<#
example output:

    PS> _term2

    {"Bad":"Invalid"}_broken
    {"Codepoint":"0x1f977","Color":"khaki","Name":"Amir Perry","Rune":"🥷"}
    {"Codepoint":"0x1f99b","Color":"black","Name":"Izabelle Lane","Rune":"🦛"}
    {"Id":"86","Name":"Makhi Bradford","Rune":"🦜"}
    {"Id":"51","Name":"Lawrence Hooper","Rune":"🧌"}
    {"Codepoint":"0x1f992","Color":"magenta","Name":"Cassius Oneal","Rune":"🦒"}
    {"Id":"13","Name":"Messiah King","Rune":"🧪"}
    {"Codepoint":"0x1f997","Color":"khaki","Name":"Julius Kim","Rune":"🦗"}
    {"Codepoint":"0x1f9d6","Color":"purple","Name":"Josephine Hunt","Rune":"🧖"}
    {"Id":"16","Name":"Soren Holmes","Rune":"🦨"}
    {"Codepoint":"0x1f984","Color":"pink","Name":"Evelin Schmidt","Rune":"🦄"}
#>

# term1
# tail0: allows sentinal to exist in the log, without having to delete it

$PSStyle.OutputRendering = 'PlainText'
$PSStyle.OutputRendering = 'Host'
$PSStyle.OutputRendering = 'Ansi'
function _term1 { 
    $splinfo = @{
        InformationAction = 'continue'
    }
    if(-not $Conf.Info) { 
        $splinfo.Remove('InformationAction')
    }

    Get-Content $Path.Log1 -Wait -Tail 0 
    | ForEach-Object { $_; if ($_ -match 'end') { break; } }
    | ForEach-Object { 
        $rawLine = $_
        try { 
            $obj? = $rawLine | ConvertFrom-Json -ea stop
            $Obj? | ConvertTo-Json | Bat -l json 
        }
        catch {
            'failed: {0}' -f @($rawLine)
            | Write-ConsoleColorZd -fg 'pink' -bg 'black'            
        }
        if(-not $Obj?) {
            '😭'
            return 
        }

        # still goods
        h1 'as Bat Pipe'
        $obj? | ConvertTo-Json | & 'bat' @('-l', 'json', '-p') # '--color=always')
        | Write-Information @splinfo
        # to get fancy, Winfo. Lets me emit the original object without mutation.
        return $obj?        
    }
    | Set-Content $Path.Log2 -PassThru 
    | ForEach-Object { 
        $_
        $_.GetType().Name | Write-Information @splinfo
        # custom formatting applies to STDOUT but not the log
        # "OnlyTerm`n    $_"
        # $_ | Join.ul
    }
}

# Term2 
Import-Module NameIt
function _term2 {
    param(
        # if not set, add extra output to test errors
        [switch]$OnlyIncludeValidOutput = $Script:Conf.OnlyValidOutput
    )
    function random.emoji { (0x1f993 - 100)..(0x1f993 + 100) |  Get-Random -Count 1 | ForEach-Object { [Text.Rune]::new( $_ ) } }
    function random.Pair {
        # assymetric output for tail to parse
        if (-not $OnlyIncludeValidOutput) {
            if ((0..6 | Get-Random -Count 1) -eq 0 ) {
                @{ Bad = 'multiLineDoc' } | ConvertTo-Json
            }
            if ((0..6 | Get-Random -Count 1) -eq 0) {
                @{ Bad = 'Invalid' } | ConvertTo-Json -Compress  | Join-String -os '_broken'
            }
        }
        $data = @{ Rune = Random.Emoji | ForEach-Object tostring 
            Name        = Ig '[person]'
        } 
        if (($True, $false | Get-Random -Count 1)) { 
            $data.Id = Ig '##'
        }
        else { 
            $data.Color = Ig '[color]'
            $data.Codepoint = $Data.Rune.EnumerateRunes().Value | hex 
        }
        $data | ConvertTo-Json -Compress
    }

    while ($true) {
        Start-Sleep -ms $Conf.LogDelayMs
        random.Pair
        | Add-Content -Path $Path.Log1 -PassThru 
    }

}

function _term3 {
    # term3
    'end' | Add-Content $Path.Log1 -PassThru
}

