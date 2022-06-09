package little.interpreter.features;

import little.exceptions.UnknownDefinition;
import little.exceptions.Typo;
using StringTools;

class Assignment {
    
    public static function assign(statement:String) {
        var assignmentSplit = statement.split("=");
        if (assignmentSplit.length == 1) return;
        if (assignmentSplit[2] == "") {
            Runtime.safeThrow(new Typo("When assigning a value to a definition, you need to fill out the value after the = sign."));
            return;
        }
        var variableOperand = assignmentSplit[-2].trim();
        var valueOperand = assignmentSplit[-1].trim();
        valueOperand = Evaluator.getValueOf(valueOperand);
        final variable = Memory.getLoadedVar(variableOperand);

        if (variable == null) Runtime.safeThrow(new UnknownDefinition(variableOperand));

        variable.basicValue = valueOperand;
        if (Interpreter.currentLine == variable.scope.initializationLine) variable.type = Typer.getValueType(valueOperand);
    }

}