# thread started at <https://discord.com/channels/180528040881815552/447476117629304853/1110201488472539296>
# About: Creating a validator to allow integers or string, nothing else.
class ValidateStringOrInt : System.Management.Automation.ValidateEnumeratedArgumentsAttribute {
    [Object]$Value
    [void]ValidateElement( $Element ) {
        $ex = [Management.Automation.MetadataException]

        if ($null -eq $Element) {
            throw $ex::new( 'Value cannot be true null null!' )
        }
        if (-not( $Element -is 'string' -or $Element -is 'int'  ) ) {
            throw  $ex::new(
                "Value '$Element' is not an [int] or [string]. Was a [$($Element.GetType().Name)]")
        }
    }
}
# inner tests to work right
Remove-Variable @('a'..'z') -ea 'ignore'
[ValidateStringOrInt()]$a = '123'
[ValidateStringOrInt()]$b = 123
[ValidateStringOrInt()]$c = '123.3'
{ [ValidateStringOrInt()]$e = 23.435 } | Should -Throw
Get-Variable @('a'..'z') -ea 'ignore' | ft

