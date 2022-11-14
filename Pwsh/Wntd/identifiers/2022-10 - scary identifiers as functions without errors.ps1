# save me: 2022-10-17

function ⸳ {
    process {
        'Invoke: u+0x2e33' | write-debug
        $_ | Join-String -sep '_' -op '[ ' -os '] '
    }
 }
# $⸳ = 4
# $a⸳2 = 9
# function `⸳ { 'z' }
334 | ⸳
⸳ 33 + 4
$x = { 'Hi world' }

'a'..'e'
# &$x ⸳ ..'e'
