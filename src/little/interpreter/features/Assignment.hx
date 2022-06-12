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
        var DefinitionOperand = assignmentSplit[0];
        var valueOperand = assignmentSplit[1].trim();
        //now, isolate the Definition's name
        DefinitionOperand = DefinitionOperand.replace("define ", "");
        if (DefinitionOperand.contains(":")) {
           DefinitionOperand =  ~/:[a-zA-Z_]+/.replace(DefinitionOperand, "");
        }
        DefinitionOperand = DefinitionOperand.replace(" ", "");
        valueOperand = Evaluator.getValueOf(valueOperand);
        final Definition = Memory.getLoadedVar(DefinitionOperand);

        if (Definition == null) Runtime.safeThrow(new UnknownDefinition(DefinitionOperand));
        if ((Definition.type == null || Definition.type == "Everything") && Interpreter.currentLine == Definition.scope.initializationLine) Definition.type = Typer.getValueType(valueOperand);
        if (Typer.getValueType(valueOperand) != Definition.type) {
            Runtime.safeThrow(new DefinitionTypeMismatch(DefinitionOperand, Definition.type, Typer.getValueType(valueOperand)));
        }
        Definition.basicValue = valueOperand;
    }

}