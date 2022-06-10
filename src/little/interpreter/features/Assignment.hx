package little.interpreter.features;

import little.exceptions.DefinitionTypeMismatch;
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
        var variableOperand = assignmentSplit[0];
        var valueOperand = assignmentSplit[1].trim();
        //now, isolate the variable's name
        variableOperand = variableOperand.replace("define ", "");
        if (variableOperand.contains(":")) {
           variableOperand =  ~/:[a-zA-Z_]+/.replace(variableOperand, "");
        }
        variableOperand = variableOperand.replace(" ", "");
        valueOperand = Evaluator.getValueOf(valueOperand);
        final variable = Memory.getLoadedVar(variableOperand);

        if (variable == null) Runtime.safeThrow(new UnknownDefinition(variableOperand));
        if ((variable.type == null || variable.type == "Everything") && Interpreter.currentLine == variable.scope.initializationLine) variable.type = Typer.getValueType(valueOperand);
        if (Typer.getValueType(valueOperand) != variable.type) {
            Runtime.safeThrow(new DefinitionTypeMismatch(variableOperand, variable.type, Typer.getValueType(valueOperand)));
        }
        variable.basicValue = valueOperand;
    }

}