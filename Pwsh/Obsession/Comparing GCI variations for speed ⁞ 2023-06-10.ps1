<#
context: <https://discord.com/channels/180528040881815552/446156137952182282/1122578719542890526>
    > Why does get-childitem -Directory -Name take longer than get-childitem -Directory

#>
$gciShare =  @{
    Recurse = $true
    ErrorAction = 'Ignore'
    Path = 'c:\windows\system32'
}
$gciShare =  @{
    Recurse = $true
    ErrorAction = 'Ignore'
    Path = '~'
    Depth = 2

}
dotils.DeltaOfSB -Expression {
        fd --search-path (gi $gciShare.Path)
            | CountOf 'Fd'
    } | % DurationMs
dotils.DeltaOfSB -Expression {
        fd --search-path (gi $gciShare.Path)
        | Get-Item
            | CountOf 'Fd | Get-Item'
    } | % DurationMs

return
write-warning 'huge, massive, performance hit on the examples that use -Name -Dir|File because of the provider paths as opposed to piping raw objects'
dotils.DeltaOfSB -Expression {
        get-childitem @gciShare
            | CountOf 'Gci'
    } | % DurationMs

dotils.DeltaOfSB -Expression {
        get-childitem @gciShare -Directory
            | CountOf 'Gci -Directory'
    } | % DurationMs

dotils.DeltaOfSB -Expression {
        get-childitem @gciShare -File
            | CountOf 'Gci -File'
    } | % DurationMs

dotils.DeltaOfSB -Expression {
        get-childitem @gciShare -Name
            | CountOf 'Gci -Name'
    } | % DurationMs

return

dotils.DeltaOfSB -Expression { # insanely slow
        get-childitem @gciShare -Name -File
            | CountOf 'Gci -Name -File'
    } | % DurationMs

dotils.DeltaOfSB -Expression {
        get-childitem @gciShare -Name -Directory
            | CountOf 'Gci -Name -Dir'
    } | % DurationMs