
using namespace System.Collections.Generic
using namespace System.Management.Automation.Language

class FindVariableValueVisitor : AstVisitor {
    [Dictionary[string, object]] $values = [Dictionary[string, object]]::new()

    [AstVisitAction] VisitAssignmentStatement(
        [AssignmentStatementAst] $assignmentStatementAst
    ) {
        if ($assignmentStatementAst.Left -isnot [VariableExpressionAst]) {
            return [AstVisitAction]::SkipChildren
        }

        try {
            $value = $assignmentStatementAst.Right.Expression.SafeGetValue()
        } catch {
            return [AstVisitAction]::SkipChildren
        }

        $this.values[$assignmentStatementAst.Left.VariablePath.UserPath] = $value
        return [AstVisitAction]::SkipChildren
    }

    static [Dictionary[string, object]] GetVariables([Ast] $ast) {
        $visitor = [FindVariableValueVisitor]::new()
        $ast.Visit($visitor)
        return $visitor.values
    }
}
