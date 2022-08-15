# [xml]$doc1 = @'
#     <?xml version="1.0" encoding="utf-8"?>
#     <EmployeeList>
#         <Human id="1234"><region>East</region></Human>
#             <Role>None</Role>
#             <AssetType>Computing</AssetType>
#         </Asset>
#     </EmployeeList>
# '@

Import-Module 'NameIt' -ea Stop
$Template = @{}
$Template.Human = @'
<Human id="####">
    <Region>[state]</Region>
    <Name>[name]</Name>
</Human>
'@

ig $Template.Human -Count 4
| Bat -l xml