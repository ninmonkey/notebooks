'
    [big reference: about_Type_Signatures](https://github.com/SeeminglyScience/ClassExplorer/blob/master/docs/en-US/about_Type_Signatures.help.md)
'
'Find all members that take a Span<> or a Memory<> as a parameter.'
[Text.Rune] | Find-Member -MemberType Method -ParameterType { [anyof[Span[any], Memory[any]]] }

'Find all methods with no parameters and with a generic parameter with the new constraint.'
Find-Member -ParameterCount 0 -GenericParameter { [T[new]] }

'Find all methods named Emit whose parameter count is any of the following:
    ..1     less than or equal to 1
    7..8    7 to 8 (inclusive
    10..    greater than or equal to 10
    ..1,7.. ( <= 1 ) or ( >= 7 )
'
Find-Member Emit -ParameterCount ..1, 7..8, 10..
Find-Member Emit -GenericParameterCount ..1, 7..8, 10..

'Find all static members in the AppDomain that return any type of AST.'
Find-Member -ReturnType System.Management.Automation.Language.Ast -Static