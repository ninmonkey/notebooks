- [ ] autogen yaml => markdown 
- `about_topic` means `concept article`
- `about_function` are docs on that literal function
- `speeddial` means good for a bookmark, launches to other pages

### Keybinding 

- [huge Excel Keybinding Reference Chart](https://support.microsoft.com/en-us/office/keyboard-shortcuts-in-excel-1798d9d5-842a-42b8-9c99-9b7213f0040f)

```yaml
- title: insert formula UI
    chord: shift+f3
    desc: While editing a formula, this opens the `insert function` GUI
    tags: ['ui', 'formula']
```

### Url Quick Ref, and concepts

```yaml
# [record]
- title: about_Duplicate_Values
    url: https://support.microsoft.com/en-us/office/filter-for-unique-values-or-remove-duplicate-values-ccf664b0-81d6-449b-bbe1-8daaec1e83c2
    desc:
    tags: [ 'about_topic' ]
- title: about_Keyboard_Shortcuts
    url: https://support.microsoft.com/en-us/office/keyboard-shortcuts-in-excel-1798d9d5-842a-42b8-9c99-9b7213f0040f
    desc: Top Level, hotkeys for literally everything. pages and pages.
    tags: [ 'about_topic', 'reference', 'best', 'huge', 'speeddial', 'toc', 'top', 'listing' ]
- title: about_Conditional_Formatting_Formulas
    url: https://support.microsoft.com/en-us/office/use-conditional-formatting-to-highlight-information-fed60dfa-1d3f-4e13-9ecb-f1951ff89d7f
    desc: Top Level, main entry point
    tags: [ 'about_topic', 'conditional_formatting', 'format', 'color', 'speeddial', 'top', 'toc' ]
- title: about_Data_Validation_More_Info
    url: https://support.microsoft.com/en-us/office/more-on-data-validation-f38dee73-9900-4ca6-9301-8a5f6e1f0c4c
    desc: More on data validation
    tags: [ 'about_topic', 'validation', 'data_validation', 'format']

- title: Function listing by Category
    url: https://support.microsoft.com/en-us/office/excel-functions-by-category-5f91f4e9-7b42-46d2-9bd1-63f26a86c0eb
    desc: top level toc, sort of a glossary
    tags: [ 'toc', 'top', 'speeddial', 'function', 'listing', 'quickref']
- title: Function listing Sorted by Name
    url: https://support.microsoft.com/en-us/office/excel-functions-alphabetical-b3944572-255d-4efb-bb96-c6d90033e188
    desc: top level toc, sort of a glossary
    tags: [ 'toc', 'top', 'speeddial', 'function', 'listing', 'quickref']

- title: about_Formulas
    url: https://support.microsoft.com/en-us/office/overview-of-formulas-in-excel-ecfdc708-9162-49e8-b993-c311f47ca173
    desc: best top-level / table of contents
    tags: ['toc', 'top', 'about_topic' ]
- title: about_Operators
    url: https://support.microsoft.com/en-us/office/using-calculation-operators-in-excel-formulas-78be92ad-563c-4d62-b081-ae6da5c2ca69
    desc: best top-level / table of contents
    tags: ['about_topic', 'operators' ]

- title: about_Array_Formula_Guidelines
    url: https://support.microsoft.com/en-us/office/guidelines-and-examples-of-array-formulas-7d94a64e-3ff3-4686-9372-ecfd5caa57c7
    desc: overview, contains pre-spill-era functions
    tags: ['about_topic', 'array', 'dynamic_array', 'about_guidelines' ]
    
- title: about_Dynamic_Array_Splills
    url: https://support.microsoft.com/en-us/office/dynamic-array-formulas-and-spilled-array-behavior-205c6b06-03ba-4151-89a1-87a7eb36e531
    desc: overview, contains pre-spill-era functions
    tags: ['about_topic', 'array', 'dynamic_array', 'about_guidelines', 'spill' ]
- title: about_Structured_References
    url: https://support.microsoft.com/en-us/office/using-structured-references-with-excel-tables-f5ed2452-2337-4f71-bed3-c8ae6d2b276e
    desc: 
    tags: ['neat', 'about_topic', 'array', 'table', 'named_reference', 'reference' ]
- title: about_Precedence
    url: https://support.microsoft.com/en-us/office/the-order-in-which-excel-performs-operations-in-formulas-28eaf0d7-7058-4eff-a8ea-0a835fafadb8
    desc: precedence and operators
    tags: ['about_topic' ]
- title: about_Implicit_Intersection_Operator_@
    url: https://support.microsoft.com/en-us/office/implicit-intersection-operator-ce3be07b-0101-4450-a24e-c1c999be2b34
    desc: precedence and operators
    tags: ['about_topic', 'operators', 'whats_new' ]

- title: about_Error_Ref
    url: https://support.microsoft.com/en-us/office/how-to-correct-a-ref-error-822c8e46-e610-4d02-bf29-ec4b8c5ff4be
    desc: fixing \#REF errors
    tags: ['about_topic', 'about_error', 'reference' ]

- title: func Cell
    url: https://support.microsoft.com/en-us/office/cell-function-51bd39a5-f338-4dbe-a33f-955d67c2b2cf?ns=excel&version=90&ui=en-us&rs=en-us&ad=us
    desc: best top-level / table of contents
    tags: ['function', 'metadata', 'about_function']
- title: func Filter
    url: https://support.microsoft.com/en-us/office/filter-function-f4f7cb66-82eb-4767-8f7c-4877ad80c759
    desc: .
    tags: ['function', 'metadata', 'about_function']
- title: func SortBy
    url: https://support.microsoft.com/en-us/office/sortby-function-cd2d7a62-1b93-435c-b561-d6a35134f28f
    desc: .
    tags: ['function', 'about_function']
- title: func Address
    url: https://support.microsoft.com/en-us/office/address-function-d0c26c0d-3991-446b-8de4-ab46431d4f89
    desc: .
    tags: ['function', 'about_function', 'formula']
    syntax: |
ADDRESS( row_num, column_num, [abs_num], [a1], [sheet_text] )    


- title: Template - Formula Tutorial
    url: https://templates.office.com/en-us/Formula-tutorial-TM16400656
    desc: interactive learning, in a workbook. from the docs. <https://support.microsoft.com/en-us/office/overview-of-formulas-in-excel-ecfdc708-9162-49e8-b993-c311f47ca173>
    longDesc: A good visual Cheatsheet comparing |
        absolute, relative and mixed references

    tags: ['template', 'debug', 'tutorial' ]

# 1 line [record]
# - martin: {name: Martin D'vloper, job: Developer, skill: Elite}

```