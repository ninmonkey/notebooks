Import-Module irregular
# new-Regex -Pattern (New-Regex -NotLiteralCharacter '(', ')') -Repeat *
$Re = @{}
$Ex = @{
    First = '( ext:ps1 ( dm:last2weeks ))'
}

$re.scratch = @'
(?x)
    ^
    # any of neither balanced character
    [^()]*

    # open: lefty parens, closing: righty parens
    \(
    (?<Open>.*)
    \)

    $
'@

$re.Balance = @'
(?x)
^
# https://regex101.com/r/dTWnVb/1
# example: https://learn.microsoft.com/en-us/dotnet/standard/base-types/grouping-constructs-in-regular-expressions#balancing-group-definitions

# any-non of neither balanced character
[^()]*

# open: lefty parens, closing: righty parens

(?<Open> \( )
# any-non
[^()]*

(
   (?<Open> \( )
   # any-non
   [^()]*
)+
# Match a right angle bracket, assign the substring between the Open group and the current group to the Close group, and delete the definition of the Open group.
#
(?<Close-Open> \) )
[^()]*
(
   (?<Close-Open> \) )
   [^()]*
)+

(
  (
    (?<Open> \( )
    [^<>]*
  )+
  (
     (?<Close-Open> \) )
     [^()]*
  )+
)*
(?(Open)(?!))
$
'@
$re.Balance
