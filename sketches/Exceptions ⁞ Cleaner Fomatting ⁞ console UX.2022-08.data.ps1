function dotSourcedException {
    param([string]$ExceptionTemplateName)

    switch($ExceptionTemplate) {
        'UnexpectedToken1' {
            $global:error()
        }
        default {
            throw "generic expection"
        }
    }
}