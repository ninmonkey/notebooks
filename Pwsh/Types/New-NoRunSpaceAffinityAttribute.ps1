@'
see: <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7.4#norunspaceaffinity-attribute>
from: <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7.4#example-4---class-definition-with-and-without-runspace-affinity>
'@
[NoRunspaceAffinity()]
class SafeClass {
    static [Object] ShowRunspaceId( $val ) {
        return [PSCustomobject]@{
            ThreadId   = [Threading.Thread]::CurrentThread.ManagedThreadId
            RunspaceId = [runspace]::DefaultRunspace.Id
        }
    }
}

function RunSafe {
    write-verbose -verbose 'this version does not error'
    $Safe = [SafeClass]::new()
    while($true) {
        0..10 | % -Parallel {
            Sleep -ms 50
            ($Using:Safe)::ShowRunspaceId($_)
        }
    }
}


class UnsafeClass {
    static [Object] ShowRunspaceId( $val ) {
        return [PSCustomobject]@{
            ThreadId   = [Threading.Thread]::CurrentThread.ManagedThreadId
            RunspaceId = [runspace]::DefaultRunspace.Id
        }
    }
}

function RunUnsafe {
    write-verbose -verbose 'this version will error like:
    WriteError:
    Line |
    3 |              ($Using:Unsafe)::ShowRunspaceId($_)
        |              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        | Global scope cannot be removed.
    '
    $Unsafe = [UnsafeClass]::new()
    while($true) {
        0..10 | % -Parallel {
            Sleep -ms 50
            ($Using:Unsafe)::ShowRunspaceId($_)
        }
    }
}
