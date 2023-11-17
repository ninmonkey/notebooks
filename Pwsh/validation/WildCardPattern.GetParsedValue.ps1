# <https://discord.com/channels/180528040881815552/447476117629304853/1156667256164581386>
$pattern = [WildcardPattern]::new('[a-z]*??')
$method = $pattern.GetType().GetProperty(
    'PatternConvertedToRegex',
    [System.Reflection.BindingFlags] 'Instance, NonPublic')
$method.GetValue($pattern) # => ^[a-z].*..$