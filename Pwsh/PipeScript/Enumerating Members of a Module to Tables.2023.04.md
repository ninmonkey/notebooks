- [try 1: saved as yaml](#try-1-saved-as-yaml)
- [try 2 : shows table](#try-2--shows-table)
- [try 3 : shows table of all](#try-3--shows-table-of-all)


<!-- get-alias | ? Source -EQ 'pipescript'|sort -->

## try 1: saved as yaml 

Output results as a yaml code-fence.

```yml
- ModuleName: Pipescript
  ResolvedCommandName: Import-PipeScript
  DisplayName: .< -> Import-PipeScript
  Segments:
  - '\.<'
  - Pipescript\.<
  Separator:
    Options: RightToLeft
    RightToLeft: true
    MatchTimeout: -00:00:00.0010000
  Synopsis: ""
  Namespace: Pipescript
  CommandType: Alias
- ModuleName: Pipescript
  ResolvedCommandName: Use-PipeScript
  DisplayName: .<ADA.Template> -> Use-PipeScript
  Segments:
  - '>'
  - .Template>
  - '\.<ADA.Template>'
  - Pipescript\.<ADA.Template>
  Separator:
    Options: RightToLeft
    RightToLeft: true
    MatchTimeout: -00:00:00.0010000
  Synopsis: ""
  Namespace: Pipescript\.<ADA.Template
  CommandType: Alias
- ModuleName: Pipescript
  ResolvedCommandName: Use-PipeScript
  DisplayName: .<Aliases> -> Use-PipeScript
  Segments:
  - '>'
  - '\.<Aliases>'
  - Pipescript\.<Aliases>
  Separator:
    Options: RightToLeft
    RightToLeft: true
    MatchTimeout: -00:00:00.0010000
  Synopsis: ""
  Namespace: Pipescript\.<Aliases
  CommandType: Alias

```
## try 2 : shows table

If an object has the property `Table`, it will automatically output as `markdown tables`


|ModuleName|ResolvedCommandName|DisplayName                      |Segments|Separator    |Synopsis             |Namespace                 |CommandType         |
|----------|-------------------|---------------------------------|--------|-------------|---------------------|--------------------------|--------------------|
|Pipescript|Import-PipeScript  |.< -> Import-PipeScript          |\.<     |Pipescript\.<|[\p{P}<>]{1,}        |Pipescript                |Alias               |
|Pipescript|Use-PipeScript     |.<ADA.Template> -> Use-PipeScript|>       |.Template>   |\.<ADA.Template>     |Pipescript\.<ADA.Template>|[\p{P}<>]{1,}       |Pipescript\.<ADA.Template|Alias|
|Pipescript|Use-PipeScript     |.<Aliases> -> Use-PipeScript     |>       |\.<Aliases>  |Pipescript\.<Aliases>|[\p{P}<>]{1,}             |Pipescript\.<Aliases|Alias                    |



## try 3 : simplified #4



|ResolvedCommandName|DisplayName                                         |Synopsis                                    |Namespace|CommandType|
|-------------------|----------------------------------------------------|--------------------------------------------|---------|-----------|
|Export-Pipescript  |bps -> Export-Pipescript                            |Pipescript                                  |Alias    |
|Export-Pipescript  |Build-PipeScript                                    |Pipescript\Build                            |Alias    |
|Export-Pipescript  |eps -> Export-Pipescript                            |Pipescript                                  |Alias    |
|Import-PipeScript  |.< -> Import-PipeScript                             |Pipescript                                  |Alias    |
|Import-PipeScript  |imps -> Import-PipeScript                           |Pipescript                                  |Alias    |
|Invoke-PipeScript  |.> -> Invoke-PipeScript                             |Pipescript                                  |Alias    |
|Invoke-PipeScript  |ips -> Invoke-PipeScript                            |Pipescript                                  |Alias    |
|Join-PipeScript    |Join-ScriptBlock                                    |Pipescript\Join                             |Alias    |
|Join-PipeScript    |jps -> Join-PipeScript                              |Pipescript                                  |Alias    |
|New-PipeScript     |New-ScriptBlock                                     |Pipescript\New                              |Alias    |
|Search-PipeScript  |Search-ScriptBlock                                  |Pipescript\Search                           |Alias    |
|Update-PipeScript  |Update-ScriptBlock                                  |Pipescript\Update                           |Alias    |
|Update-PipeScript  |ups -> Update-PipeScript                            |Pipescript                                  |Alias    |
|Use-PipeScript     |.<ADA.Template> -> Use-PipeScript                   |Pipescript\.<ADA.Template                   |Alias    |
|Use-PipeScript     |.<Aliases> -> Use-PipeScript                        |Pipescript\.<Aliases                        |Alias    |
|Use-PipeScript     |.<All> -> Use-PipeScript                            |Pipescript\.<All                            |Alias    |
|Use-PipeScript     |.<Arduino.Template> -> Use-PipeScript               |Pipescript\.<Arduino.Template               |Alias    |
|Use-PipeScript     |.<Assert> -> Use-PipeScript                         |Pipescript\.<Assert                         |Alias    |
|Use-PipeScript     |.<ATOM.Template> -> Use-PipeScript                  |Pipescript\.<ATOM.Template                  |Alias    |
|Use-PipeScript     |.<Await> -> Use-PipeScript                          |Pipescript\.<Await                          |Alias    |
|Use-PipeScript     |.<Bash.Template> -> Use-PipeScript                  |Pipescript\.<Bash.Template                  |Alias    |
|Use-PipeScript     |.<Bash> -> Use-PipeScript                           |Pipescript\.<Bash                           |Alias    |
|Use-PipeScript     |.<Basic.Template> -> Use-PipeScript                 |Pipescript\.<Basic.Template                 |Alias    |
|Use-PipeScript     |.<Batch.Template> -> Use-PipeScript                 |Pipescript\.<Batch.Template                 |Alias    |
|Use-PipeScript     |.<Batch> -> Use-PipeScript                          |Pipescript\.<Batch                          |Alias    |
|Use-PipeScript     |.<BatchPowerShell> -> Use-PipeScript                |Pipescript\.<BatchPowerShell                |Alias    |
|Use-PipeScript     |.<Bicep.Template> -> Use-PipeScript                 |Pipescript\.<Bicep.Template                 |Alias    |
|Use-PipeScript     |.<ConditionalKeyword> -> Use-PipeScript             |Pipescript\.<ConditionalKeyword             |Alias    |
|Use-PipeScript     |.<CPlusPlus.Template> -> Use-PipeScript             |Pipescript\.<CPlusPlus.Template             |Alias    |
|Use-PipeScript     |.<CSharp.Template> -> Use-PipeScript                |Pipescript\.<CSharp.Template                |Alias    |
|Use-PipeScript     |.<CSS.Template> -> Use-PipeScript                   |Pipescript\.<CSS.Template                   |Alias    |
|Use-PipeScript     |.<Dart.Template> -> Use-PipeScript                  |Pipescript\.<Dart.Template                  |Alias    |
|Use-PipeScript     |.<Decorate> -> Use-PipeScript                       |Pipescript\.<Decorate                       |Alias    |
|Use-PipeScript     |.<Define> -> Use-PipeScript                         |Pipescript\.<Define                         |Alias    |
|Use-PipeScript     |.<Dot> -> Use-PipeScript                            |Pipescript\.<Dot                            |Alias    |
|Use-PipeScript     |.<EqualityComparison> -> Use-PipeScript             |Pipescript\.<EqualityComparison             |Alias    |
|Use-PipeScript     |.<EqualityTypeComparison> -> Use-PipeScript         |Pipescript\.<EqualityTypeComparison         |Alias    |
|Use-PipeScript     |.<Explicit> -> Use-PipeScript                       |Pipescript\.<Explicit                       |Alias    |
|Use-PipeScript     |.<Go.Template> -> Use-PipeScript                    |Pipescript\.<Go.Template                    |Alias    |
|Use-PipeScript     |.<HAXE.Template> -> Use-PipeScript                  |Pipescript\.<HAXE.Template                  |Alias    |
|Use-PipeScript     |.<HCL.Template> -> Use-PipeScript                   |Pipescript\.<HCL.Template                   |Alias    |
|Use-PipeScript     |.<Help> -> Use-PipeScript                           |Pipescript\.<Help                           |Alias    |
|Use-PipeScript     |.<HLSL.Template> -> Use-PipeScript                  |Pipescript\.<HLSL.Template                  |Alias    |
|Use-PipeScript     |.<HTML.Template> -> Use-PipeScript                  |Pipescript\.<HTML.Template                  |Alias    |
|Use-PipeScript     |.<Http.Protocol> -> Use-PipeScript                  |Pipescript\.<Http.Protocol                  |Alias    |
|Use-PipeScript     |.<Include> -> Use-PipeScript                        |Pipescript\.<Include                        |Alias    |
|Use-PipeScript     |.<Inherit> -> Use-PipeScript                        |Pipescript\.<Inherit                        |Alias    |
|Use-PipeScript     |.<Java.Template> -> Use-PipeScript                  |Pipescript\.<Java.Template                  |Alias    |
|Use-PipeScript     |.<JavaScript.Template> -> Use-PipeScript            |Pipescript\.<JavaScript.Template            |Alias    |
|Use-PipeScript     |.<Json.Template> -> Use-PipeScript                  |Pipescript\.<Json.Template                  |Alias    |
|Use-PipeScript     |.<JSONSchema.Protocol> -> Use-PipeScript            |Pipescript\.<JSONSchema.Protocol            |Alias    |
|Use-PipeScript     |.<Kotlin.Template> -> Use-PipeScript                |Pipescript\.<Kotlin.Template                |Alias    |
|Use-PipeScript     |.<Latex.Template> -> Use-PipeScript                 |Pipescript\.<Latex.Template                 |Alias    |
|Use-PipeScript     |.<LUA.Template> -> Use-PipeScript                   |Pipescript\.<LUA.Template                   |Alias    |
|Use-PipeScript     |.<Markdown.Template> -> Use-PipeScript              |Pipescript\.<Markdown.Template              |Alias    |
|Use-PipeScript     |.<ModuleExports> -> Use-PipeScript                  |Pipescript\.<ModuleExports                  |Alias    |
|Use-PipeScript     |.<ModuleRelationship> -> Use-PipeScript             |Pipescript\.<ModuleRelationship             |Alias    |
|Use-PipeScript     |.<NamespacedAlias> -> Use-PipeScript                |Pipescript\.<NamespacedAlias                |Alias    |
|Use-PipeScript     |.<NamespacedFunction> -> Use-PipeScript             |Pipescript\.<NamespacedFunction             |Alias    |
|Use-PipeScript     |.<New> -> Use-PipeScript                            |Pipescript\.<New                            |Alias    |
|Use-PipeScript     |.<ObjectiveC.Template> -> Use-PipeScript            |Pipescript\.<ObjectiveC.Template            |Alias    |
|Use-PipeScript     |.<OpenSCAD.Template> -> Use-PipeScript              |Pipescript\.<OpenSCAD.Template              |Alias    |
|Use-PipeScript     |.<OutputFile> -> Use-PipeScript                     |Pipescript\.<OutputFile                     |Alias    |
|Use-PipeScript     |.<Perl.Template> -> Use-PipeScript                  |Pipescript\.<Perl.Template                  |Alias    |
|Use-PipeScript     |.<PHP.Template> -> Use-PipeScript                   |Pipescript\.<PHP.Template                   |Alias    |
|Use-PipeScript     |.<PipedAssignment> -> Use-PipeScript                |Pipescript\.<PipedAssignment                |Alias    |
|Use-PipeScript     |.<PipeScript.AttributedExpression> -> Use-PipeScript|Pipescript\.<PipeScript.AttributedExpression|Alias    |
|Use-PipeScript     |.<Pipescript.FunctionDefinition> -> Use-PipeScript  |Pipescript\.<Pipescript.FunctionDefinition  |Alias    |
|Use-PipeScript     |.<PipeScript.ParameterAttribute> -> Use-PipeScript  |Pipescript\.<PipeScript.ParameterAttribute  |Alias    |
|Use-PipeScript     |.<PipeScript.Protocol> -> Use-PipeScript            |Pipescript\.<PipeScript.Protocol            |Alias    |
|Use-PipeScript     |.<PipeScript.Template> -> Use-PipeScript            |Pipescript\.<PipeScript.Template            |Alias    |
|Use-PipeScript     |.<PipeScript.TypeConstraint> -> Use-PipeScript      |Pipescript\.<PipeScript.TypeConstraint      |Alias    |
|Use-PipeScript     |.<PipeScript.TypeExpression> -> Use-PipeScript      |Pipescript\.<PipeScript.TypeExpression      |Alias    |
|Use-PipeScript     |.<Pipescript> -> Use-PipeScript                     |Pipescript\.<Pipescript                     |Alias    |
|Use-PipeScript     |.<ProxyCommand> -> Use-PipeScript                   |Pipescript\.<ProxyCommand                   |Alias    |
|Use-PipeScript     |.<PSD1.Template> -> Use-PipeScript                  |Pipescript\.<PSD1.Template                  |Alias    |
|Use-PipeScript     |.<Python.Template> -> Use-PipeScript                |Pipescript\.<Python.Template                |Alias    |
|Use-PipeScript     |.<R.Template> -> Use-PipeScript                     |Pipescript\.<R.Template                     |Alias    |
|Use-PipeScript     |.<Racket.Template> -> Use-PipeScript                |Pipescript\.<Racket.Template                |Alias    |
|Use-PipeScript     |.<Razor.Template> -> Use-PipeScript                 |Pipescript\.<Razor.Template                 |Alias    |
|Use-PipeScript     |.<RegexLiteral> -> Use-PipeScript                   |Pipescript\.<RegexLiteral                   |Alias    |
|Use-PipeScript     |.<RemoveParameter> -> Use-PipeScript                |Pipescript\.<RemoveParameter                |Alias    |
|Use-PipeScript     |.<RenameVariable> -> Use-PipeScript                 |Pipescript\.<RenameVariable                 |Alias    |
|Use-PipeScript     |.<Requires> -> Use-PipeScript                       |Pipescript\.<Requires                       |Alias    |
|Use-PipeScript     |.<Rest> -> Use-PipeScript                           |Pipescript\.<Rest                           |Alias    |
|Use-PipeScript     |.<RSS.Template> -> Use-PipeScript                   |Pipescript\.<RSS.Template                   |Alias    |
|Use-PipeScript     |.<Ruby.Template> -> Use-PipeScript                  |Pipescript\.<Ruby.Template                  |Alias    |
|Use-PipeScript     |.<Rust.Template> -> Use-PipeScript                  |Pipescript\.<Rust.Template                  |Alias    |
|Use-PipeScript     |.<Scala.Template> -> Use-PipeScript                 |Pipescript\.<Scala.Template                 |Alias    |
|Use-PipeScript     |.<SQL.Template> -> Use-PipeScript                   |Pipescript\.<SQL.Template                   |Alias    |
|Use-PipeScript     |.<TCL.Template> -> Use-PipeScript                   |Pipescript\.<TCL.Template                   |Alias    |
|Use-PipeScript     |.<TOML.Template> -> Use-PipeScript                  |Pipescript\.<TOML.Template                  |Alias    |
|Use-PipeScript     |.<TypeScript.Template> -> Use-PipeScript            |Pipescript\.<TypeScript.Template            |Alias    |
|Use-PipeScript     |.<UDP.Protocol> -> Use-PipeScript                   |Pipescript\.<UDP.Protocol                   |Alias    |
|Use-PipeScript     |.<Until> -> Use-PipeScript                          |Pipescript\.<Until                          |Alias    |
|Use-PipeScript     |.<ValidateExtension> -> Use-PipeScript              |Pipescript\.<ValidateExtension              |Alias    |
|Use-PipeScript     |.<ValidatePlatform> -> Use-PipeScript               |Pipescript\.<ValidatePlatform               |Alias    |
|Use-PipeScript     |.<ValidatePropertyName> -> Use-PipeScript           |Pipescript\.<ValidatePropertyName           |Alias    |
|Use-PipeScript     |.<ValidateScriptBlock> -> Use-PipeScript            |Pipescript\.<ValidateScriptBlock            |Alias    |
|Use-PipeScript     |.<ValidateTypes> -> Use-PipeScript                  |Pipescript\.<ValidateTypes                  |Alias    |
|Use-PipeScript     |.<VBN> -> Use-PipeScript                            |Pipescript\.<VBN                            |Alias    |
|Use-PipeScript     |.<VFP> -> Use-PipeScript                            |Pipescript\.<VFP                            |Alias    |
|Use-PipeScript     |.<WebAssembly.Template> -> Use-PipeScript           |Pipescript\.<WebAssembly.Template           |Alias    |
|Use-PipeScript     |.<XML.Template> -> Use-PipeScript                   |Pipescript\.<XML.Template                   |Alias    |
|Use-PipeScript     |.<YAML.Template> -> Use-PipeScript                  |Pipescript\.<YAML.Template                  |Alias    |
|Use-PipeScript     |.>ADA.Template -> Use-PipeScript                    |Pipescript\.>ADA                            |Alias    |
|Use-PipeScript     |.>Aliases -> Use-PipeScript                         |Pipescript                                  |Alias    |
|Use-PipeScript     |.>All -> Use-PipeScript                             |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Arduino.Template -> Use-PipeScript                |Pipescript\.>Arduino                        |Alias    |
|Use-PipeScript     |.>Assert -> Use-PipeScript                          |Pipescript                                  |Alias    |
|Use-PipeScript     |.>ATOM.Template -> Use-PipeScript                   |Pipescript\.>ATOM                           |Alias    |
|Use-PipeScript     |.>Await -> Use-PipeScript                           |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Bash -> Use-PipeScript                            |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Bash.Template -> Use-PipeScript                   |Pipescript\.>Bash                           |Alias    |
|Use-PipeScript     |.>Basic.Template -> Use-PipeScript                  |Pipescript\.>Basic                          |Alias    |
|Use-PipeScript     |.>Batch -> Use-PipeScript                           |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Batch.Template -> Use-PipeScript                  |Pipescript\.>Batch                          |Alias    |
|Use-PipeScript     |.>BatchPowerShell -> Use-PipeScript                 |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Bicep.Template -> Use-PipeScript                  |Pipescript\.>Bicep                          |Alias    |
|Use-PipeScript     |.>ConditionalKeyword -> Use-PipeScript              |Pipescript                                  |Alias    |
|Use-PipeScript     |.>CPlusPlus.Template -> Use-PipeScript              |Pipescript\.>CPlusPlus                      |Alias    |
|Use-PipeScript     |.>CSharp.Template -> Use-PipeScript                 |Pipescript\.>CSharp                         |Alias    |
|Use-PipeScript     |.>CSS.Template -> Use-PipeScript                    |Pipescript\.>CSS                            |Alias    |
|Use-PipeScript     |.>Dart.Template -> Use-PipeScript                   |Pipescript\.>Dart                           |Alias    |
|Use-PipeScript     |.>Decorate -> Use-PipeScript                        |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Define -> Use-PipeScript                          |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Dot -> Use-PipeScript                             |Pipescript                                  |Alias    |
|Use-PipeScript     |.>EqualityComparison -> Use-PipeScript              |Pipescript                                  |Alias    |
|Use-PipeScript     |.>EqualityTypeComparison -> Use-PipeScript          |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Explicit -> Use-PipeScript                        |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Go.Template -> Use-PipeScript                     |Pipescript\.>Go                             |Alias    |
|Use-PipeScript     |.>HAXE.Template -> Use-PipeScript                   |Pipescript\.>HAXE                           |Alias    |
|Use-PipeScript     |.>HCL.Template -> Use-PipeScript                    |Pipescript\.>HCL                            |Alias    |
|Use-PipeScript     |.>Help -> Use-PipeScript                            |Pipescript                                  |Alias    |
|Use-PipeScript     |.>HLSL.Template -> Use-PipeScript                   |Pipescript\.>HLSL                           |Alias    |
|Use-PipeScript     |.>HTML.Template -> Use-PipeScript                   |Pipescript\.>HTML                           |Alias    |
|Use-PipeScript     |.>Http.Protocol -> Use-PipeScript                   |Pipescript\.>Http                           |Alias    |
|Use-PipeScript     |.>Include -> Use-PipeScript                         |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Inherit -> Use-PipeScript                         |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Java.Template -> Use-PipeScript                   |Pipescript\.>Java                           |Alias    |
|Use-PipeScript     |.>JavaScript.Template -> Use-PipeScript             |Pipescript\.>JavaScript                     |Alias    |
|Use-PipeScript     |.>Json.Template -> Use-PipeScript                   |Pipescript\.>Json                           |Alias    |
|Use-PipeScript     |.>JSONSchema.Protocol -> Use-PipeScript             |Pipescript\.>JSONSchema                     |Alias    |
|Use-PipeScript     |.>Kotlin.Template -> Use-PipeScript                 |Pipescript\.>Kotlin                         |Alias    |
|Use-PipeScript     |.>Latex.Template -> Use-PipeScript                  |Pipescript\.>Latex                          |Alias    |
|Use-PipeScript     |.>LUA.Template -> Use-PipeScript                    |Pipescript\.>LUA                            |Alias    |
|Use-PipeScript     |.>Markdown.Template -> Use-PipeScript               |Pipescript\.>Markdown                       |Alias    |
|Use-PipeScript     |.>ModuleExports -> Use-PipeScript                   |Pipescript                                  |Alias    |
|Use-PipeScript     |.>ModuleRelationship -> Use-PipeScript              |Pipescript                                  |Alias    |
|Use-PipeScript     |.>NamespacedAlias -> Use-PipeScript                 |Pipescript                                  |Alias    |
|Use-PipeScript     |.>NamespacedFunction -> Use-PipeScript              |Pipescript                                  |Alias    |
|Use-PipeScript     |.>New -> Use-PipeScript                             |Pipescript                                  |Alias    |
|Use-PipeScript     |.>ObjectiveC.Template -> Use-PipeScript             |Pipescript\.>ObjectiveC                     |Alias    |
|Use-PipeScript     |.>OpenSCAD.Template -> Use-PipeScript               |Pipescript\.>OpenSCAD                       |Alias    |
|Use-PipeScript     |.>OutputFile -> Use-PipeScript                      |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Perl.Template -> Use-PipeScript                   |Pipescript\.>Perl                           |Alias    |
|Use-PipeScript     |.>PHP.Template -> Use-PipeScript                    |Pipescript\.>PHP                            |Alias    |
|Use-PipeScript     |.>PipedAssignment -> Use-PipeScript                 |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Pipescript -> Use-PipeScript                      |Pipescript                                  |Alias    |
|Use-PipeScript     |.>PipeScript.AttributedExpression -> Use-PipeScript |Pipescript\.>PipeScript                     |Alias    |
|Use-PipeScript     |.>Pipescript.FunctionDefinition -> Use-PipeScript   |Pipescript\.>Pipescript                     |Alias    |
|Use-PipeScript     |.>PipeScript.ParameterAttribute -> Use-PipeScript   |Pipescript\.>PipeScript                     |Alias    |
|Use-PipeScript     |.>PipeScript.Protocol -> Use-PipeScript             |Pipescript\.>PipeScript                     |Alias    |
|Use-PipeScript     |.>PipeScript.Template -> Use-PipeScript             |Pipescript\.>PipeScript                     |Alias    |
|Use-PipeScript     |.>PipeScript.TypeConstraint -> Use-PipeScript       |Pipescript\.>PipeScript                     |Alias    |
|Use-PipeScript     |.>PipeScript.TypeExpression -> Use-PipeScript       |Pipescript\.>PipeScript                     |Alias    |
|Use-PipeScript     |.>ProxyCommand -> Use-PipeScript                    |Pipescript                                  |Alias    |
|Use-PipeScript     |.>PSD1.Template -> Use-PipeScript                   |Pipescript\.>PSD1                           |Alias    |
|Use-PipeScript     |.>Python.Template -> Use-PipeScript                 |Pipescript\.>Python                         |Alias    |
|Use-PipeScript     |.>R.Template -> Use-PipeScript                      |Pipescript\.>R                              |Alias    |
|Use-PipeScript     |.>Racket.Template -> Use-PipeScript                 |Pipescript\.>Racket                         |Alias    |
|Use-PipeScript     |.>Razor.Template -> Use-PipeScript                  |Pipescript\.>Razor                          |Alias    |
|Use-PipeScript     |.>RegexLiteral -> Use-PipeScript                    |Pipescript                                  |Alias    |
|Use-PipeScript     |.>RemoveParameter -> Use-PipeScript                 |Pipescript                                  |Alias    |
|Use-PipeScript     |.>RenameVariable -> Use-PipeScript                  |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Requires -> Use-PipeScript                        |Pipescript                                  |Alias    |
|Use-PipeScript     |.>Rest -> Use-PipeScript                            |Pipescript                                  |Alias    |
|Use-PipeScript     |.>RSS.Template -> Use-PipeScript                    |Pipescript\.>RSS                            |Alias    |
|Use-PipeScript     |.>Ruby.Template -> Use-PipeScript                   |Pipescript\.>Ruby                           |Alias    |
|Use-PipeScript     |.>Rust.Template -> Use-PipeScript                   |Pipescript\.>Rust                           |Alias    |
|Use-PipeScript     |.>Scala.Template -> Use-PipeScript                  |Pipescript\.>Scala                          |Alias    |
|Use-PipeScript     |.>SQL.Template -> Use-PipeScript                    |Pipescript\.>SQL                            |Alias    |
|Use-PipeScript     |.>TCL.Template -> Use-PipeScript                    |Pipescript\.>TCL                            |Alias    |
|Use-PipeScript     |.>TOML.Template -> Use-PipeScript                   |Pipescript\.>TOML                           |Alias    |
|Use-PipeScript     |.>TypeScript.Template -> Use-PipeScript             |Pipescript\.>TypeScript                     |Alias    |
|Use-PipeScript     |.>UDP.Protocol -> Use-PipeScript                    |Pipescript\.>UDP                            |Alias    |
|Use-PipeScript     |.>Until -> Use-PipeScript                           |Pipescript                                  |Alias    |
|Use-PipeScript     |.>ValidateExtension -> Use-PipeScript               |Pipescript                                  |Alias    |
|Use-PipeScript     |.>ValidatePlatform -> Use-PipeScript                |Pipescript                                  |Alias    |
|Use-PipeScript     |.>ValidatePropertyName -> Use-PipeScript            |Pipescript                                  |Alias    |
|Use-PipeScript     |.>ValidateScriptBlock -> Use-PipeScript             |Pipescript                                  |Alias    |
|Use-PipeScript     |.>ValidateTypes -> Use-PipeScript                   |Pipescript                                  |Alias    |
|Use-PipeScript     |.>VBN -> Use-PipeScript                             |Pipescript                                  |Alias    |
|Use-PipeScript     |.>VFP -> Use-PipeScript                             |Pipescript                                  |Alias    |
|Use-PipeScript     |.>WebAssembly.Template -> Use-PipeScript            |Pipescript\.>WebAssembly                    |Alias    |
|Use-PipeScript     |.>XML.Template -> Use-PipeScript                    |Pipescript\.>XML                            |Alias    |
|Use-PipeScript     |.>YAML.Template -> Use-PipeScript                   |Pipescript\.>YAML                           |Alias    |
|Use-PipeScript     |All -> Use-PipeScript                               |Pipescript                                  |Alias    |
|Use-PipeScript     |New -> Use-PipeScript                               |Pipescript                                  |Alias    |
|Use-PipeScript     |Requires -> Use-PipeScript                          |Pipescript                                  |Alias    |
|Use-PipeScript     |Until -> Use-PipeScript                             |Pipescript                                  |Alias    |



## Try 4 verbose


|ResolvedCommandName|DisplayName                                         |Segments                 |Separator                          |Synopsis                                    |Namespace                                    |CommandType                        |
|-------------------|----------------------------------------------------|-------------------------|-----------------------------------|--------------------------------------------|---------------------------------------------|-----------------------------------|
|Import-PipeScript  |.< -> Import-PipeScript                             |\.<                      |Pipescript\.<                      |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.<ADA.Template> -> Use-PipeScript                   |>                        |.Template>                         |\.<ADA.Template>                            |Pipescript\.<ADA.Template>                   |[\p{P}<>]{1,}                      |Pipescript\.<ADA.Template                   |Alias|
|Use-PipeScript     |.<Aliases> -> Use-PipeScript                        |>                        |\.<Aliases>                        |Pipescript\.<Aliases>                       |[\p{P}<>]{1,}                                |Pipescript\.<Aliases               |Alias                                       |
|Use-PipeScript     |.<All> -> Use-PipeScript                            |>                        |\.<All>                            |Pipescript\.<All>                           |[\p{P}<>]{1,}                                |Pipescript\.<All                   |Alias                                       |
|Use-PipeScript     |.<Arduino.Template> -> Use-PipeScript               |>                        |.Template>                         |\.<Arduino.Template>                        |Pipescript\.<Arduino.Template>               |[\p{P}<>]{1,}                      |Pipescript\.<Arduino.Template               |Alias|
|Use-PipeScript     |.<Assert> -> Use-PipeScript                         |>                        |\.<Assert>                         |Pipescript\.<Assert>                        |[\p{P}<>]{1,}                                |Pipescript\.<Assert                |Alias                                       |
|Use-PipeScript     |.<ATOM.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<ATOM.Template>                           |Pipescript\.<ATOM.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<ATOM.Template                  |Alias|
|Use-PipeScript     |.<Await> -> Use-PipeScript                          |>                        |\.<Await>                          |Pipescript\.<Await>                         |[\p{P}<>]{1,}                                |Pipescript\.<Await                 |Alias                                       |
|Use-PipeScript     |.<Bash.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<Bash.Template>                           |Pipescript\.<Bash.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<Bash.Template                  |Alias|
|Use-PipeScript     |.<Bash> -> Use-PipeScript                           |>                        |\.<Bash>                           |Pipescript\.<Bash>                          |[\p{P}<>]{1,}                                |Pipescript\.<Bash                  |Alias                                       |
|Use-PipeScript     |.<Basic.Template> -> Use-PipeScript                 |>                        |.Template>                         |\.<Basic.Template>                          |Pipescript\.<Basic.Template>                 |[\p{P}<>]{1,}                      |Pipescript\.<Basic.Template                 |Alias|
|Use-PipeScript     |.<Batch.Template> -> Use-PipeScript                 |>                        |.Template>                         |\.<Batch.Template>                          |Pipescript\.<Batch.Template>                 |[\p{P}<>]{1,}                      |Pipescript\.<Batch.Template                 |Alias|
|Use-PipeScript     |.<Batch> -> Use-PipeScript                          |>                        |\.<Batch>                          |Pipescript\.<Batch>                         |[\p{P}<>]{1,}                                |Pipescript\.<Batch                 |Alias                                       |
|Use-PipeScript     |.<BatchPowerShell> -> Use-PipeScript                |>                        |\.<BatchPowerShell>                |Pipescript\.<BatchPowerShell>               |[\p{P}<>]{1,}                                |Pipescript\.<BatchPowerShell       |Alias                                       |
|Use-PipeScript     |.<Bicep.Template> -> Use-PipeScript                 |>                        |.Template>                         |\.<Bicep.Template>                          |Pipescript\.<Bicep.Template>                 |[\p{P}<>]{1,}                      |Pipescript\.<Bicep.Template                 |Alias|
|Use-PipeScript     |.<ConditionalKeyword> -> Use-PipeScript             |>                        |\.<ConditionalKeyword>             |Pipescript\.<ConditionalKeyword>            |[\p{P}<>]{1,}                                |Pipescript\.<ConditionalKeyword    |Alias                                       |
|Use-PipeScript     |.<CPlusPlus.Template> -> Use-PipeScript             |>                        |.Template>                         |\.<CPlusPlus.Template>                      |Pipescript\.<CPlusPlus.Template>             |[\p{P}<>]{1,}                      |Pipescript\.<CPlusPlus.Template             |Alias|
|Use-PipeScript     |.<CSharp.Template> -> Use-PipeScript                |>                        |.Template>                         |\.<CSharp.Template>                         |Pipescript\.<CSharp.Template>                |[\p{P}<>]{1,}                      |Pipescript\.<CSharp.Template                |Alias|
|Use-PipeScript     |.<CSS.Template> -> Use-PipeScript                   |>                        |.Template>                         |\.<CSS.Template>                            |Pipescript\.<CSS.Template>                   |[\p{P}<>]{1,}                      |Pipescript\.<CSS.Template                   |Alias|
|Use-PipeScript     |.<Dart.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<Dart.Template>                           |Pipescript\.<Dart.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<Dart.Template                  |Alias|
|Use-PipeScript     |.<Decorate> -> Use-PipeScript                       |>                        |\.<Decorate>                       |Pipescript\.<Decorate>                      |[\p{P}<>]{1,}                                |Pipescript\.<Decorate              |Alias                                       |
|Use-PipeScript     |.<Define> -> Use-PipeScript                         |>                        |\.<Define>                         |Pipescript\.<Define>                        |[\p{P}<>]{1,}                                |Pipescript\.<Define                |Alias                                       |
|Use-PipeScript     |.<Dot> -> Use-PipeScript                            |>                        |\.<Dot>                            |Pipescript\.<Dot>                           |[\p{P}<>]{1,}                                |Pipescript\.<Dot                   |Alias                                       |
|Use-PipeScript     |.<EqualityComparison> -> Use-PipeScript             |>                        |\.<EqualityComparison>             |Pipescript\.<EqualityComparison>            |[\p{P}<>]{1,}                                |Pipescript\.<EqualityComparison    |Alias                                       |
|Use-PipeScript     |.<EqualityTypeComparison> -> Use-PipeScript         |>                        |\.<EqualityTypeComparison>         |Pipescript\.<EqualityTypeComparison>        |[\p{P}<>]{1,}                                |Pipescript\.<EqualityTypeComparison|Alias                                       |
|Use-PipeScript     |.<Explicit> -> Use-PipeScript                       |>                        |\.<Explicit>                       |Pipescript\.<Explicit>                      |[\p{P}<>]{1,}                                |Pipescript\.<Explicit              |Alias                                       |
|Use-PipeScript     |.<Go.Template> -> Use-PipeScript                    |>                        |.Template>                         |\.<Go.Template>                             |Pipescript\.<Go.Template>                    |[\p{P}<>]{1,}                      |Pipescript\.<Go.Template                    |Alias|
|Use-PipeScript     |.<HAXE.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<HAXE.Template>                           |Pipescript\.<HAXE.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<HAXE.Template                  |Alias|
|Use-PipeScript     |.<HCL.Template> -> Use-PipeScript                   |>                        |.Template>                         |\.<HCL.Template>                            |Pipescript\.<HCL.Template>                   |[\p{P}<>]{1,}                      |Pipescript\.<HCL.Template                   |Alias|
|Use-PipeScript     |.<Help> -> Use-PipeScript                           |>                        |\.<Help>                           |Pipescript\.<Help>                          |[\p{P}<>]{1,}                                |Pipescript\.<Help                  |Alias                                       |
|Use-PipeScript     |.<HLSL.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<HLSL.Template>                           |Pipescript\.<HLSL.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<HLSL.Template                  |Alias|
|Use-PipeScript     |.<HTML.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<HTML.Template>                           |Pipescript\.<HTML.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<HTML.Template                  |Alias|
|Use-PipeScript     |.<Http.Protocol> -> Use-PipeScript                  |>                        |.Protocol>                         |\.<Http.Protocol>                           |Pipescript\.<Http.Protocol>                  |[\p{P}<>]{1,}                      |Pipescript\.<Http.Protocol                  |Alias|
|Use-PipeScript     |.<Include> -> Use-PipeScript                        |>                        |\.<Include>                        |Pipescript\.<Include>                       |[\p{P}<>]{1,}                                |Pipescript\.<Include               |Alias                                       |
|Use-PipeScript     |.<Inherit> -> Use-PipeScript                        |>                        |\.<Inherit>                        |Pipescript\.<Inherit>                       |[\p{P}<>]{1,}                                |Pipescript\.<Inherit               |Alias                                       |
|Use-PipeScript     |.<Java.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<Java.Template>                           |Pipescript\.<Java.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<Java.Template                  |Alias|
|Use-PipeScript     |.<JavaScript.Template> -> Use-PipeScript            |>                        |.Template>                         |\.<JavaScript.Template>                     |Pipescript\.<JavaScript.Template>            |[\p{P}<>]{1,}                      |Pipescript\.<JavaScript.Template            |Alias|
|Use-PipeScript     |.<Json.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<Json.Template>                           |Pipescript\.<Json.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<Json.Template                  |Alias|
|Use-PipeScript     |.<JSONSchema.Protocol> -> Use-PipeScript            |>                        |.Protocol>                         |\.<JSONSchema.Protocol>                     |Pipescript\.<JSONSchema.Protocol>            |[\p{P}<>]{1,}                      |Pipescript\.<JSONSchema.Protocol            |Alias|
|Use-PipeScript     |.<Kotlin.Template> -> Use-PipeScript                |>                        |.Template>                         |\.<Kotlin.Template>                         |Pipescript\.<Kotlin.Template>                |[\p{P}<>]{1,}                      |Pipescript\.<Kotlin.Template                |Alias|
|Use-PipeScript     |.<Latex.Template> -> Use-PipeScript                 |>                        |.Template>                         |\.<Latex.Template>                          |Pipescript\.<Latex.Template>                 |[\p{P}<>]{1,}                      |Pipescript\.<Latex.Template                 |Alias|
|Use-PipeScript     |.<LUA.Template> -> Use-PipeScript                   |>                        |.Template>                         |\.<LUA.Template>                            |Pipescript\.<LUA.Template>                   |[\p{P}<>]{1,}                      |Pipescript\.<LUA.Template                   |Alias|
|Use-PipeScript     |.<Markdown.Template> -> Use-PipeScript              |>                        |.Template>                         |\.<Markdown.Template>                       |Pipescript\.<Markdown.Template>              |[\p{P}<>]{1,}                      |Pipescript\.<Markdown.Template              |Alias|
|Use-PipeScript     |.<ModuleExports> -> Use-PipeScript                  |>                        |\.<ModuleExports>                  |Pipescript\.<ModuleExports>                 |[\p{P}<>]{1,}                                |Pipescript\.<ModuleExports         |Alias                                       |
|Use-PipeScript     |.<ModuleRelationship> -> Use-PipeScript             |>                        |\.<ModuleRelationship>             |Pipescript\.<ModuleRelationship>            |[\p{P}<>]{1,}                                |Pipescript\.<ModuleRelationship    |Alias                                       |
|Use-PipeScript     |.<NamespacedAlias> -> Use-PipeScript                |>                        |\.<NamespacedAlias>                |Pipescript\.<NamespacedAlias>               |[\p{P}<>]{1,}                                |Pipescript\.<NamespacedAlias       |Alias                                       |
|Use-PipeScript     |.<NamespacedFunction> -> Use-PipeScript             |>                        |\.<NamespacedFunction>             |Pipescript\.<NamespacedFunction>            |[\p{P}<>]{1,}                                |Pipescript\.<NamespacedFunction    |Alias                                       |
|Use-PipeScript     |.<New> -> Use-PipeScript                            |>                        |\.<New>                            |Pipescript\.<New>                           |[\p{P}<>]{1,}                                |Pipescript\.<New                   |Alias                                       |
|Use-PipeScript     |.<ObjectiveC.Template> -> Use-PipeScript            |>                        |.Template>                         |\.<ObjectiveC.Template>                     |Pipescript\.<ObjectiveC.Template>            |[\p{P}<>]{1,}                      |Pipescript\.<ObjectiveC.Template            |Alias|
|Use-PipeScript     |.<OpenSCAD.Template> -> Use-PipeScript              |>                        |.Template>                         |\.<OpenSCAD.Template>                       |Pipescript\.<OpenSCAD.Template>              |[\p{P}<>]{1,}                      |Pipescript\.<OpenSCAD.Template              |Alias|
|Use-PipeScript     |.<OutputFile> -> Use-PipeScript                     |>                        |\.<OutputFile>                     |Pipescript\.<OutputFile>                    |[\p{P}<>]{1,}                                |Pipescript\.<OutputFile            |Alias                                       |
|Use-PipeScript     |.<Perl.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<Perl.Template>                           |Pipescript\.<Perl.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<Perl.Template                  |Alias|
|Use-PipeScript     |.<PHP.Template> -> Use-PipeScript                   |>                        |.Template>                         |\.<PHP.Template>                            |Pipescript\.<PHP.Template>                   |[\p{P}<>]{1,}                      |Pipescript\.<PHP.Template                   |Alias|
|Use-PipeScript     |.<PipedAssignment> -> Use-PipeScript                |>                        |\.<PipedAssignment>                |Pipescript\.<PipedAssignment>               |[\p{P}<>]{1,}                                |Pipescript\.<PipedAssignment       |Alias                                       |
|Use-PipeScript     |.<PipeScript.AttributedExpression> -> Use-PipeScript|>                        |.AttributedExpression>             |\.<PipeScript.AttributedExpression>         |Pipescript\.<PipeScript.AttributedExpression>|[\p{P}<>]{1,}                      |Pipescript\.<PipeScript.AttributedExpression|Alias|
|Use-PipeScript     |.<Pipescript.FunctionDefinition> -> Use-PipeScript  |>                        |.FunctionDefinition>               |\.<Pipescript.FunctionDefinition>           |Pipescript\.<Pipescript.FunctionDefinition>  |[\p{P}<>]{1,}                      |Pipescript\.<Pipescript.FunctionDefinition  |Alias|
|Use-PipeScript     |.<PipeScript.ParameterAttribute> -> Use-PipeScript  |>                        |.ParameterAttribute>               |\.<PipeScript.ParameterAttribute>           |Pipescript\.<PipeScript.ParameterAttribute>  |[\p{P}<>]{1,}                      |Pipescript\.<PipeScript.ParameterAttribute  |Alias|
|Use-PipeScript     |.<PipeScript.Protocol> -> Use-PipeScript            |>                        |.Protocol>                         |\.<PipeScript.Protocol>                     |Pipescript\.<PipeScript.Protocol>            |[\p{P}<>]{1,}                      |Pipescript\.<PipeScript.Protocol            |Alias|
|Use-PipeScript     |.<PipeScript.Template> -> Use-PipeScript            |>                        |.Template>                         |\.<PipeScript.Template>                     |Pipescript\.<PipeScript.Template>            |[\p{P}<>]{1,}                      |Pipescript\.<PipeScript.Template            |Alias|
|Use-PipeScript     |.<PipeScript.TypeConstraint> -> Use-PipeScript      |>                        |.TypeConstraint>                   |\.<PipeScript.TypeConstraint>               |Pipescript\.<PipeScript.TypeConstraint>      |[\p{P}<>]{1,}                      |Pipescript\.<PipeScript.TypeConstraint      |Alias|
|Use-PipeScript     |.<PipeScript.TypeExpression> -> Use-PipeScript      |>                        |.TypeExpression>                   |\.<PipeScript.TypeExpression>               |Pipescript\.<PipeScript.TypeExpression>      |[\p{P}<>]{1,}                      |Pipescript\.<PipeScript.TypeExpression      |Alias|
|Use-PipeScript     |.<Pipescript> -> Use-PipeScript                     |>                        |\.<Pipescript>                     |Pipescript\.<Pipescript>                    |[\p{P}<>]{1,}                                |Pipescript\.<Pipescript            |Alias                                       |
|Use-PipeScript     |.<ProxyCommand> -> Use-PipeScript                   |>                        |\.<ProxyCommand>                   |Pipescript\.<ProxyCommand>                  |[\p{P}<>]{1,}                                |Pipescript\.<ProxyCommand          |Alias                                       |
|Use-PipeScript     |.<PSD1.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<PSD1.Template>                           |Pipescript\.<PSD1.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<PSD1.Template                  |Alias|
|Use-PipeScript     |.<Python.Template> -> Use-PipeScript                |>                        |.Template>                         |\.<Python.Template>                         |Pipescript\.<Python.Template>                |[\p{P}<>]{1,}                      |Pipescript\.<Python.Template                |Alias|
|Use-PipeScript     |.<R.Template> -> Use-PipeScript                     |>                        |.Template>                         |\.<R.Template>                              |Pipescript\.<R.Template>                     |[\p{P}<>]{1,}                      |Pipescript\.<R.Template                     |Alias|
|Use-PipeScript     |.<Racket.Template> -> Use-PipeScript                |>                        |.Template>                         |\.<Racket.Template>                         |Pipescript\.<Racket.Template>                |[\p{P}<>]{1,}                      |Pipescript\.<Racket.Template                |Alias|
|Use-PipeScript     |.<Razor.Template> -> Use-PipeScript                 |>                        |.Template>                         |\.<Razor.Template>                          |Pipescript\.<Razor.Template>                 |[\p{P}<>]{1,}                      |Pipescript\.<Razor.Template                 |Alias|
|Use-PipeScript     |.<RegexLiteral> -> Use-PipeScript                   |>                        |\.<RegexLiteral>                   |Pipescript\.<RegexLiteral>                  |[\p{P}<>]{1,}                                |Pipescript\.<RegexLiteral          |Alias                                       |
|Use-PipeScript     |.<RemoveParameter> -> Use-PipeScript                |>                        |\.<RemoveParameter>                |Pipescript\.<RemoveParameter>               |[\p{P}<>]{1,}                                |Pipescript\.<RemoveParameter       |Alias                                       |
|Use-PipeScript     |.<RenameVariable> -> Use-PipeScript                 |>                        |\.<RenameVariable>                 |Pipescript\.<RenameVariable>                |[\p{P}<>]{1,}                                |Pipescript\.<RenameVariable        |Alias                                       |
|Use-PipeScript     |.<Requires> -> Use-PipeScript                       |>                        |\.<Requires>                       |Pipescript\.<Requires>                      |[\p{P}<>]{1,}                                |Pipescript\.<Requires              |Alias                                       |
|Use-PipeScript     |.<Rest> -> Use-PipeScript                           |>                        |\.<Rest>                           |Pipescript\.<Rest>                          |[\p{P}<>]{1,}                                |Pipescript\.<Rest                  |Alias                                       |
|Use-PipeScript     |.<RSS.Template> -> Use-PipeScript                   |>                        |.Template>                         |\.<RSS.Template>                            |Pipescript\.<RSS.Template>                   |[\p{P}<>]{1,}                      |Pipescript\.<RSS.Template                   |Alias|
|Use-PipeScript     |.<Ruby.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<Ruby.Template>                           |Pipescript\.<Ruby.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<Ruby.Template                  |Alias|
|Use-PipeScript     |.<Rust.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<Rust.Template>                           |Pipescript\.<Rust.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<Rust.Template                  |Alias|
|Use-PipeScript     |.<Scala.Template> -> Use-PipeScript                 |>                        |.Template>                         |\.<Scala.Template>                          |Pipescript\.<Scala.Template>                 |[\p{P}<>]{1,}                      |Pipescript\.<Scala.Template                 |Alias|
|Use-PipeScript     |.<SQL.Template> -> Use-PipeScript                   |>                        |.Template>                         |\.<SQL.Template>                            |Pipescript\.<SQL.Template>                   |[\p{P}<>]{1,}                      |Pipescript\.<SQL.Template                   |Alias|
|Use-PipeScript     |.<TCL.Template> -> Use-PipeScript                   |>                        |.Template>                         |\.<TCL.Template>                            |Pipescript\.<TCL.Template>                   |[\p{P}<>]{1,}                      |Pipescript\.<TCL.Template                   |Alias|
|Use-PipeScript     |.<TOML.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<TOML.Template>                           |Pipescript\.<TOML.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<TOML.Template                  |Alias|
|Use-PipeScript     |.<TypeScript.Template> -> Use-PipeScript            |>                        |.Template>                         |\.<TypeScript.Template>                     |Pipescript\.<TypeScript.Template>            |[\p{P}<>]{1,}                      |Pipescript\.<TypeScript.Template            |Alias|
|Use-PipeScript     |.<UDP.Protocol> -> Use-PipeScript                   |>                        |.Protocol>                         |\.<UDP.Protocol>                            |Pipescript\.<UDP.Protocol>                   |[\p{P}<>]{1,}                      |Pipescript\.<UDP.Protocol                   |Alias|
|Use-PipeScript     |.<Until> -> Use-PipeScript                          |>                        |\.<Until>                          |Pipescript\.<Until>                         |[\p{P}<>]{1,}                                |Pipescript\.<Until                 |Alias                                       |
|Use-PipeScript     |.<ValidateExtension> -> Use-PipeScript              |>                        |\.<ValidateExtension>              |Pipescript\.<ValidateExtension>             |[\p{P}<>]{1,}                                |Pipescript\.<ValidateExtension     |Alias                                       |
|Use-PipeScript     |.<ValidatePlatform> -> Use-PipeScript               |>                        |\.<ValidatePlatform>               |Pipescript\.<ValidatePlatform>              |[\p{P}<>]{1,}                                |Pipescript\.<ValidatePlatform      |Alias                                       |
|Use-PipeScript     |.<ValidatePropertyName> -> Use-PipeScript           |>                        |\.<ValidatePropertyName>           |Pipescript\.<ValidatePropertyName>          |[\p{P}<>]{1,}                                |Pipescript\.<ValidatePropertyName  |Alias                                       |
|Use-PipeScript     |.<ValidateScriptBlock> -> Use-PipeScript            |>                        |\.<ValidateScriptBlock>            |Pipescript\.<ValidateScriptBlock>           |[\p{P}<>]{1,}                                |Pipescript\.<ValidateScriptBlock   |Alias                                       |
|Use-PipeScript     |.<ValidateTypes> -> Use-PipeScript                  |>                        |\.<ValidateTypes>                  |Pipescript\.<ValidateTypes>                 |[\p{P}<>]{1,}                                |Pipescript\.<ValidateTypes         |Alias                                       |
|Use-PipeScript     |.<VBN> -> Use-PipeScript                            |>                        |\.<VBN>                            |Pipescript\.<VBN>                           |[\p{P}<>]{1,}                                |Pipescript\.<VBN                   |Alias                                       |
|Use-PipeScript     |.<VFP> -> Use-PipeScript                            |>                        |\.<VFP>                            |Pipescript\.<VFP>                           |[\p{P}<>]{1,}                                |Pipescript\.<VFP                   |Alias                                       |
|Use-PipeScript     |.<WebAssembly.Template> -> Use-PipeScript           |>                        |.Template>                         |\.<WebAssembly.Template>                    |Pipescript\.<WebAssembly.Template>           |[\p{P}<>]{1,}                      |Pipescript\.<WebAssembly.Template           |Alias|
|Use-PipeScript     |.<XML.Template> -> Use-PipeScript                   |>                        |.Template>                         |\.<XML.Template>                            |Pipescript\.<XML.Template>                   |[\p{P}<>]{1,}                      |Pipescript\.<XML.Template                   |Alias|
|Use-PipeScript     |.<YAML.Template> -> Use-PipeScript                  |>                        |.Template>                         |\.<YAML.Template>                           |Pipescript\.<YAML.Template>                  |[\p{P}<>]{1,}                      |Pipescript\.<YAML.Template                  |Alias|
|Invoke-PipeScript  |.> -> Invoke-PipeScript                             |\.>                      |Pipescript\.>                      |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>ADA.Template -> Use-PipeScript                    |.Template                |\.>ADA.Template                    |Pipescript\.>ADA.Template                   |[\p{P}<>]{1,}                                |Pipescript\.>ADA                   |Alias                                       |
|Use-PipeScript     |.>Aliases -> Use-PipeScript                         |\.>Aliases               |Pipescript\.>Aliases               |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>All -> Use-PipeScript                             |\.>All                   |Pipescript\.>All                   |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Arduino.Template -> Use-PipeScript                |.Template                |\.>Arduino.Template                |Pipescript\.>Arduino.Template               |[\p{P}<>]{1,}                                |Pipescript\.>Arduino               |Alias                                       |
|Use-PipeScript     |.>Assert -> Use-PipeScript                          |\.>Assert                |Pipescript\.>Assert                |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>ATOM.Template -> Use-PipeScript                   |.Template                |\.>ATOM.Template                   |Pipescript\.>ATOM.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>ATOM                  |Alias                                       |
|Use-PipeScript     |.>Await -> Use-PipeScript                           |\.>Await                 |Pipescript\.>Await                 |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Bash -> Use-PipeScript                            |\.>Bash                  |Pipescript\.>Bash                  |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Bash.Template -> Use-PipeScript                   |.Template                |\.>Bash.Template                   |Pipescript\.>Bash.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>Bash                  |Alias                                       |
|Use-PipeScript     |.>Basic.Template -> Use-PipeScript                  |.Template                |\.>Basic.Template                  |Pipescript\.>Basic.Template                 |[\p{P}<>]{1,}                                |Pipescript\.>Basic                 |Alias                                       |
|Use-PipeScript     |.>Batch -> Use-PipeScript                           |\.>Batch                 |Pipescript\.>Batch                 |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Batch.Template -> Use-PipeScript                  |.Template                |\.>Batch.Template                  |Pipescript\.>Batch.Template                 |[\p{P}<>]{1,}                                |Pipescript\.>Batch                 |Alias                                       |
|Use-PipeScript     |.>BatchPowerShell -> Use-PipeScript                 |\.>BatchPowerShell       |Pipescript\.>BatchPowerShell       |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Bicep.Template -> Use-PipeScript                  |.Template                |\.>Bicep.Template                  |Pipescript\.>Bicep.Template                 |[\p{P}<>]{1,}                                |Pipescript\.>Bicep                 |Alias                                       |
|Use-PipeScript     |.>ConditionalKeyword -> Use-PipeScript              |\.>ConditionalKeyword    |Pipescript\.>ConditionalKeyword    |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>CPlusPlus.Template -> Use-PipeScript              |.Template                |\.>CPlusPlus.Template              |Pipescript\.>CPlusPlus.Template             |[\p{P}<>]{1,}                                |Pipescript\.>CPlusPlus             |Alias                                       |
|Use-PipeScript     |.>CSharp.Template -> Use-PipeScript                 |.Template                |\.>CSharp.Template                 |Pipescript\.>CSharp.Template                |[\p{P}<>]{1,}                                |Pipescript\.>CSharp                |Alias                                       |
|Use-PipeScript     |.>CSS.Template -> Use-PipeScript                    |.Template                |\.>CSS.Template                    |Pipescript\.>CSS.Template                   |[\p{P}<>]{1,}                                |Pipescript\.>CSS                   |Alias                                       |
|Use-PipeScript     |.>Dart.Template -> Use-PipeScript                   |.Template                |\.>Dart.Template                   |Pipescript\.>Dart.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>Dart                  |Alias                                       |
|Use-PipeScript     |.>Decorate -> Use-PipeScript                        |\.>Decorate              |Pipescript\.>Decorate              |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Define -> Use-PipeScript                          |\.>Define                |Pipescript\.>Define                |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Dot -> Use-PipeScript                             |\.>Dot                   |Pipescript\.>Dot                   |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>EqualityComparison -> Use-PipeScript              |\.>EqualityComparison    |Pipescript\.>EqualityComparison    |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>EqualityTypeComparison -> Use-PipeScript          |\.>EqualityTypeComparison|Pipescript\.>EqualityTypeComparison|[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Explicit -> Use-PipeScript                        |\.>Explicit              |Pipescript\.>Explicit              |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Go.Template -> Use-PipeScript                     |.Template                |\.>Go.Template                     |Pipescript\.>Go.Template                    |[\p{P}<>]{1,}                                |Pipescript\.>Go                    |Alias                                       |
|Use-PipeScript     |.>HAXE.Template -> Use-PipeScript                   |.Template                |\.>HAXE.Template                   |Pipescript\.>HAXE.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>HAXE                  |Alias                                       |
|Use-PipeScript     |.>HCL.Template -> Use-PipeScript                    |.Template                |\.>HCL.Template                    |Pipescript\.>HCL.Template                   |[\p{P}<>]{1,}                                |Pipescript\.>HCL                   |Alias                                       |
|Use-PipeScript     |.>Help -> Use-PipeScript                            |\.>Help                  |Pipescript\.>Help                  |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>HLSL.Template -> Use-PipeScript                   |.Template                |\.>HLSL.Template                   |Pipescript\.>HLSL.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>HLSL                  |Alias                                       |
|Use-PipeScript     |.>HTML.Template -> Use-PipeScript                   |.Template                |\.>HTML.Template                   |Pipescript\.>HTML.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>HTML                  |Alias                                       |
|Use-PipeScript     |.>Http.Protocol -> Use-PipeScript                   |.Protocol                |\.>Http.Protocol                   |Pipescript\.>Http.Protocol                  |[\p{P}<>]{1,}                                |Pipescript\.>Http                  |Alias                                       |
|Use-PipeScript     |.>Include -> Use-PipeScript                         |\.>Include               |Pipescript\.>Include               |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Inherit -> Use-PipeScript                         |\.>Inherit               |Pipescript\.>Inherit               |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Java.Template -> Use-PipeScript                   |.Template                |\.>Java.Template                   |Pipescript\.>Java.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>Java                  |Alias                                       |
|Use-PipeScript     |.>JavaScript.Template -> Use-PipeScript             |.Template                |\.>JavaScript.Template             |Pipescript\.>JavaScript.Template            |[\p{P}<>]{1,}                                |Pipescript\.>JavaScript            |Alias                                       |
|Use-PipeScript     |.>Json.Template -> Use-PipeScript                   |.Template                |\.>Json.Template                   |Pipescript\.>Json.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>Json                  |Alias                                       |
|Use-PipeScript     |.>JSONSchema.Protocol -> Use-PipeScript             |.Protocol                |\.>JSONSchema.Protocol             |Pipescript\.>JSONSchema.Protocol            |[\p{P}<>]{1,}                                |Pipescript\.>JSONSchema            |Alias                                       |
|Use-PipeScript     |.>Kotlin.Template -> Use-PipeScript                 |.Template                |\.>Kotlin.Template                 |Pipescript\.>Kotlin.Template                |[\p{P}<>]{1,}                                |Pipescript\.>Kotlin                |Alias                                       |
|Use-PipeScript     |.>Latex.Template -> Use-PipeScript                  |.Template                |\.>Latex.Template                  |Pipescript\.>Latex.Template                 |[\p{P}<>]{1,}                                |Pipescript\.>Latex                 |Alias                                       |
|Use-PipeScript     |.>LUA.Template -> Use-PipeScript                    |.Template                |\.>LUA.Template                    |Pipescript\.>LUA.Template                   |[\p{P}<>]{1,}                                |Pipescript\.>LUA                   |Alias                                       |
|Use-PipeScript     |.>Markdown.Template -> Use-PipeScript               |.Template                |\.>Markdown.Template               |Pipescript\.>Markdown.Template              |[\p{P}<>]{1,}                                |Pipescript\.>Markdown              |Alias                                       |
|Use-PipeScript     |.>ModuleExports -> Use-PipeScript                   |\.>ModuleExports         |Pipescript\.>ModuleExports         |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>ModuleRelationship -> Use-PipeScript              |\.>ModuleRelationship    |Pipescript\.>ModuleRelationship    |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>NamespacedAlias -> Use-PipeScript                 |\.>NamespacedAlias       |Pipescript\.>NamespacedAlias       |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>NamespacedFunction -> Use-PipeScript              |\.>NamespacedFunction    |Pipescript\.>NamespacedFunction    |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>New -> Use-PipeScript                             |\.>New                   |Pipescript\.>New                   |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>ObjectiveC.Template -> Use-PipeScript             |.Template                |\.>ObjectiveC.Template             |Pipescript\.>ObjectiveC.Template            |[\p{P}<>]{1,}                                |Pipescript\.>ObjectiveC            |Alias                                       |
|Use-PipeScript     |.>OpenSCAD.Template -> Use-PipeScript               |.Template                |\.>OpenSCAD.Template               |Pipescript\.>OpenSCAD.Template              |[\p{P}<>]{1,}                                |Pipescript\.>OpenSCAD              |Alias                                       |
|Use-PipeScript     |.>OutputFile -> Use-PipeScript                      |\.>OutputFile            |Pipescript\.>OutputFile            |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Perl.Template -> Use-PipeScript                   |.Template                |\.>Perl.Template                   |Pipescript\.>Perl.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>Perl                  |Alias                                       |
|Use-PipeScript     |.>PHP.Template -> Use-PipeScript                    |.Template                |\.>PHP.Template                    |Pipescript\.>PHP.Template                   |[\p{P}<>]{1,}                                |Pipescript\.>PHP                   |Alias                                       |
|Use-PipeScript     |.>PipedAssignment -> Use-PipeScript                 |\.>PipedAssignment       |Pipescript\.>PipedAssignment       |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Pipescript -> Use-PipeScript                      |\.>Pipescript            |Pipescript\.>Pipescript            |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>PipeScript.AttributedExpression -> Use-PipeScript |.AttributedExpression    |\.>PipeScript.AttributedExpression |Pipescript\.>PipeScript.AttributedExpression|[\p{P}<>]{1,}                                |Pipescript\.>PipeScript            |Alias                                       |
|Use-PipeScript     |.>Pipescript.FunctionDefinition -> Use-PipeScript   |.FunctionDefinition      |\.>Pipescript.FunctionDefinition   |Pipescript\.>Pipescript.FunctionDefinition  |[\p{P}<>]{1,}                                |Pipescript\.>Pipescript            |Alias                                       |
|Use-PipeScript     |.>PipeScript.ParameterAttribute -> Use-PipeScript   |.ParameterAttribute      |\.>PipeScript.ParameterAttribute   |Pipescript\.>PipeScript.ParameterAttribute  |[\p{P}<>]{1,}                                |Pipescript\.>PipeScript            |Alias                                       |
|Use-PipeScript     |.>PipeScript.Protocol -> Use-PipeScript             |.Protocol                |\.>PipeScript.Protocol             |Pipescript\.>PipeScript.Protocol            |[\p{P}<>]{1,}                                |Pipescript\.>PipeScript            |Alias                                       |
|Use-PipeScript     |.>PipeScript.Template -> Use-PipeScript             |.Template                |\.>PipeScript.Template             |Pipescript\.>PipeScript.Template            |[\p{P}<>]{1,}                                |Pipescript\.>PipeScript            |Alias                                       |
|Use-PipeScript     |.>PipeScript.TypeConstraint -> Use-PipeScript       |.TypeConstraint          |\.>PipeScript.TypeConstraint       |Pipescript\.>PipeScript.TypeConstraint      |[\p{P}<>]{1,}                                |Pipescript\.>PipeScript            |Alias                                       |
|Use-PipeScript     |.>PipeScript.TypeExpression -> Use-PipeScript       |.TypeExpression          |\.>PipeScript.TypeExpression       |Pipescript\.>PipeScript.TypeExpression      |[\p{P}<>]{1,}                                |Pipescript\.>PipeScript            |Alias                                       |
|Use-PipeScript     |.>ProxyCommand -> Use-PipeScript                    |\.>ProxyCommand          |Pipescript\.>ProxyCommand          |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>PSD1.Template -> Use-PipeScript                   |.Template                |\.>PSD1.Template                   |Pipescript\.>PSD1.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>PSD1                  |Alias                                       |
|Use-PipeScript     |.>Python.Template -> Use-PipeScript                 |.Template                |\.>Python.Template                 |Pipescript\.>Python.Template                |[\p{P}<>]{1,}                                |Pipescript\.>Python                |Alias                                       |
|Use-PipeScript     |.>R.Template -> Use-PipeScript                      |.Template                |\.>R.Template                      |Pipescript\.>R.Template                     |[\p{P}<>]{1,}                                |Pipescript\.>R                     |Alias                                       |
|Use-PipeScript     |.>Racket.Template -> Use-PipeScript                 |.Template                |\.>Racket.Template                 |Pipescript\.>Racket.Template                |[\p{P}<>]{1,}                                |Pipescript\.>Racket                |Alias                                       |
|Use-PipeScript     |.>Razor.Template -> Use-PipeScript                  |.Template                |\.>Razor.Template                  |Pipescript\.>Razor.Template                 |[\p{P}<>]{1,}                                |Pipescript\.>Razor                 |Alias                                       |
|Use-PipeScript     |.>RegexLiteral -> Use-PipeScript                    |\.>RegexLiteral          |Pipescript\.>RegexLiteral          |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>RemoveParameter -> Use-PipeScript                 |\.>RemoveParameter       |Pipescript\.>RemoveParameter       |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>RenameVariable -> Use-PipeScript                  |\.>RenameVariable        |Pipescript\.>RenameVariable        |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Requires -> Use-PipeScript                        |\.>Requires              |Pipescript\.>Requires              |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>Rest -> Use-PipeScript                            |\.>Rest                  |Pipescript\.>Rest                  |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>RSS.Template -> Use-PipeScript                    |.Template                |\.>RSS.Template                    |Pipescript\.>RSS.Template                   |[\p{P}<>]{1,}                                |Pipescript\.>RSS                   |Alias                                       |
|Use-PipeScript     |.>Ruby.Template -> Use-PipeScript                   |.Template                |\.>Ruby.Template                   |Pipescript\.>Ruby.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>Ruby                  |Alias                                       |
|Use-PipeScript     |.>Rust.Template -> Use-PipeScript                   |.Template                |\.>Rust.Template                   |Pipescript\.>Rust.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>Rust                  |Alias                                       |
|Use-PipeScript     |.>Scala.Template -> Use-PipeScript                  |.Template                |\.>Scala.Template                  |Pipescript\.>Scala.Template                 |[\p{P}<>]{1,}                                |Pipescript\.>Scala                 |Alias                                       |
|Use-PipeScript     |.>SQL.Template -> Use-PipeScript                    |.Template                |\.>SQL.Template                    |Pipescript\.>SQL.Template                   |[\p{P}<>]{1,}                                |Pipescript\.>SQL                   |Alias                                       |
|Use-PipeScript     |.>TCL.Template -> Use-PipeScript                    |.Template                |\.>TCL.Template                    |Pipescript\.>TCL.Template                   |[\p{P}<>]{1,}                                |Pipescript\.>TCL                   |Alias                                       |
|Use-PipeScript     |.>TOML.Template -> Use-PipeScript                   |.Template                |\.>TOML.Template                   |Pipescript\.>TOML.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>TOML                  |Alias                                       |
|Use-PipeScript     |.>TypeScript.Template -> Use-PipeScript             |.Template                |\.>TypeScript.Template             |Pipescript\.>TypeScript.Template            |[\p{P}<>]{1,}                                |Pipescript\.>TypeScript            |Alias                                       |
|Use-PipeScript     |.>UDP.Protocol -> Use-PipeScript                    |.Protocol                |\.>UDP.Protocol                    |Pipescript\.>UDP.Protocol                   |[\p{P}<>]{1,}                                |Pipescript\.>UDP                   |Alias                                       |
|Use-PipeScript     |.>Until -> Use-PipeScript                           |\.>Until                 |Pipescript\.>Until                 |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>ValidateExtension -> Use-PipeScript               |\.>ValidateExtension     |Pipescript\.>ValidateExtension     |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>ValidatePlatform -> Use-PipeScript                |\.>ValidatePlatform      |Pipescript\.>ValidatePlatform      |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>ValidatePropertyName -> Use-PipeScript            |\.>ValidatePropertyName  |Pipescript\.>ValidatePropertyName  |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>ValidateScriptBlock -> Use-PipeScript             |\.>ValidateScriptBlock   |Pipescript\.>ValidateScriptBlock   |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>ValidateTypes -> Use-PipeScript                   |\.>ValidateTypes         |Pipescript\.>ValidateTypes         |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>VBN -> Use-PipeScript                             |\.>VBN                   |Pipescript\.>VBN                   |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>VFP -> Use-PipeScript                             |\.>VFP                   |Pipescript\.>VFP                   |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |.>WebAssembly.Template -> Use-PipeScript            |.Template                |\.>WebAssembly.Template            |Pipescript\.>WebAssembly.Template           |[\p{P}<>]{1,}                                |Pipescript\.>WebAssembly           |Alias                                       |
|Use-PipeScript     |.>XML.Template -> Use-PipeScript                    |.Template                |\.>XML.Template                    |Pipescript\.>XML.Template                   |[\p{P}<>]{1,}                                |Pipescript\.>XML                   |Alias                                       |
|Use-PipeScript     |.>YAML.Template -> Use-PipeScript                   |.Template                |\.>YAML.Template                   |Pipescript\.>YAML.Template                  |[\p{P}<>]{1,}                                |Pipescript\.>YAML                  |Alias                                       |
|Use-PipeScript     |All -> Use-PipeScript                               |\All                     |Pipescript\All                     |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Export-Pipescript  |bps -> Export-Pipescript                            |\bps                     |Pipescript\bps                     |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Export-Pipescript  |Build-PipeScript                                    |-PipeScript              |\Build-PipeScript                  |Pipescript\Build-PipeScript                 |[\p{P}<>]{1,}                                |Pipescript\Build                   |Alias                                       |
|Export-Pipescript  |eps -> Export-Pipescript                            |\eps                     |Pipescript\eps                     |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Import-PipeScript  |imps -> Import-PipeScript                           |\imps                    |Pipescript\imps                    |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Invoke-PipeScript  |ips -> Invoke-PipeScript                            |\ips                     |Pipescript\ips                     |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Join-PipeScript    |Join-ScriptBlock                                    |-ScriptBlock             |\Join-ScriptBlock                  |Pipescript\Join-ScriptBlock                 |[\p{P}<>]{1,}                                |Pipescript\Join                    |Alias                                       |
|Join-PipeScript    |jps -> Join-PipeScript                              |\jps                     |Pipescript\jps                     |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Use-PipeScript     |New -> Use-PipeScript                               |\New                     |Pipescript\New                     |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|New-PipeScript     |New-ScriptBlock                                     |-ScriptBlock             |\New-ScriptBlock                   |Pipescript\New-ScriptBlock                  |[\p{P}<>]{1,}                                |Pipescript\New                     |Alias                                       |
|Use-PipeScript     |Requires -> Use-PipeScript                          |\Requires                |Pipescript\Requires                |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Search-PipeScript  |Search-ScriptBlock                                  |-ScriptBlock             |\Search-ScriptBlock                |Pipescript\Search-ScriptBlock               |[\p{P}<>]{1,}                                |Pipescript\Search                  |Alias                                       |
|Use-PipeScript     |Until -> Use-PipeScript                             |\Until                   |Pipescript\Until                   |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |
|Update-PipeScript  |Update-ScriptBlock                                  |-ScriptBlock             |\Update-ScriptBlock                |Pipescript\Update-ScriptBlock               |[\p{P}<>]{1,}                                |Pipescript\Update                  |Alias                                       |
|Update-PipeScript  |ups -> Update-PipeScript                            |\ups                     |Pipescript\ups                     |[\p{P}<>]{1,}                               |Pipescript                                   |Alias                              |







