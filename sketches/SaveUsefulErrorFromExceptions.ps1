function SaveUsefulErrorFromExceptions { 
    [Alias('SueFex.0')]
    param()
}

function sue_ErrorCategoryInfo { 
    <#
    .SYNOPSIS
        sue: [ErrorCategoryInfo] serialize (or flatten objects) to capture error info
    .link
        Get-Error
    .EXAMPLE
        $error.CategoryInfo | sue_ErrorCategoryInfo |ft
        $error | sue_ErrorCategoryInfo |ft
    #>
    param( 
        [Alias('InputObject')]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Management.Automation.ErrorCategoryInfo]$CategoryInfo
        
    )
    process { 
        # re-order fields
        $fieldOrder = 'Activity', 'Reason', 'TargetName'
        
        $CategoryInfo | to->Json | from->json
    }
}
function sue_ErrorRecord { 
    <#
    .SYNOPSIS
        sue: [ErrorRecord] serialize (or flatten objects) to error info
    .link
        Get-Error
    .NOTES
        [ErrorRecord] members e x
            1 [ErrorCategoryInfo]
            1 [ErrorDetails]
            1 [Exception]
            1 [InvocationInfo]
            1 [ReadOnlyCollection<int>]
            2 [object]
            2 [string]
    .EXAMPLE
        $error.CategoryInfo | sue_ErrorCategoryInfo |ft
        $error | sue_ErrorCategoryInfo |ft
    #>
    param( 
        [Alias('InputObject')]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Management.Automation.ErrorRecord]$ErrorRecord
        
    )
    process { 
        # re-order fields
        $fieldOrder = 'Activity', 'Reason', 'TargetName'
        
        $CategoryInfo | to->Json | from->json
    }
}

function ___schema_of_object {
    $onlyNewErr | s -First 10 | ForEach-Object InvocationInfo
    | ForEach-Object {
        hr
       ($_ | iot2 -NotSkipMost -PassThru).Reported | Group-Object
    }
}

function sue_schemaOfObject { 
    <#
    .SYNOPSIS
        sue:  type summaries 
    .link
        Get-Error
    .NOTES
        [ErrorRecord] members e x
            1 [ErrorCategoryInfo]
            1 [ErrorDetails]
            1 [Exception]
            1 [InvocationInfo]
            1 [ReadOnlyCollection<int>]
            2 [object]
            2 [string]
    .EXAMPLE
        $error.CategoryInfo | sue_ErrorCategoryInfo |ft
        $error | sue_ErrorCategoryInfo |ft
    #>
    param( 
        
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        [Parameter()]
        [int]$Limit = 10        
    )
    begin {
        [Collections.Generic.List[object]]$items = @()
    }
    process { 
        $items.Add( $InputObject ) 
    }
    end { 
        $items | select -First $Limit | ForEach-Object {            
            hr
             
            # this
            # $_.GetType() | shortType | Label 'Type'
            #simplifes to 
            $_ | shortType | Label 'Type'


            #  [string]$_.GetType() 
            # '{0}' -f @(
            #     $_.GetType() | shortType
            # ) | Label 'Type'
                
             
            ($_ | iot2 -NotSkipMost -PassThru).Reported | Group-Object
        }
    }
}


# throw 'nyi'
# $onlyNewErr | s -First 3 
# | %{ 
#     hr;
#     ($_ | iot2 -NotSkipMost -PassThru).Reported | group
# }  

# | select -first 3 -prop Category, Activity, Reason, TargetName, TargetType