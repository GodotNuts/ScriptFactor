extends Node
class_name Replacers

class Replacer extends RefCounted:
    var code_editor : CodeEdit
    func replace(editor : CodeEdit, what : String, for_what : String) -> void:
        code_editor = editor
        _on_replace(what, for_what)

    func _on_replace(what : String, for_what : String) -> void:
        assert(false) # Just for the base class

class VariableReplacer extends Replacer:
    const ONREADY = "@onready "
    const NAME = "#NAME#"
    const VALUE = "#VALUE#"
    const TEMPLATE = "var " + NAME + " = " + VALUE
    const ONREADY_CHECKS = "$%" # Skipping get_node for now, since few people use it outside of advanced contexts, but may add it back in with something below

    func _on_replace(context : String, with_name : String) -> void:
        var variable_value = TEMPLATE.replace(VALUE, context).replace(NAME, with_name)

        # Go to top of file, find first empty line, insert a line, then insert the variable declaration
        var idx = 0

        code_editor.text = code_editor.text.replace(context, with_name)

        while not code_editor.get_line(idx).is_empty():
            idx += 1

        var has_onready = false
        for ch in ONREADY_CHECKS:
            if context.contains(ch):
                has_onready = true
                break

        if has_onready:
            variable_value = ONREADY + variable_value

        variable_value = "\n" + variable_value

        code_editor.insert_line_at(idx, variable_value)

class ConstReplacer extends Replacer:
    const CONST = "const "
    const NAME = "#NAME#"
    const VALUE = "#VALUE#"
    const TEMPLATE = CONST + NAME + " = " + VALUE
    const ONREADY_CHECKS = "$%" # Skipping get_node for now, since few people use it outside of advanced contexts, but may add it back in with something below

    func _on_replace(context : String, with_name : String) -> void:
        for ch in ONREADY_CHECKS:
            if context.contains(ch):
                return

        var variable_value = TEMPLATE.replace(VALUE, context).replace(NAME, with_name)

        # Go to top of file, find first empty line, insert a line, then insert the variable declaration
        var idx = 0

        code_editor.text = code_editor.text.replace(context, with_name)

        while not code_editor.get_line(idx).is_empty():
            idx += 1

        variable_value = "\n" + variable_value

        code_editor.insert_line_at(idx, variable_value)
#
#class ParameterReplacer extends Replacer:
    ## INCLUDE THE TYPE IF POSSIBLE - maybe in the name interface, have a second field you can tab to that has the parameter type?
    #const VALUE = "#VALUE#"
    #const NAME = "#NAME#"
    #const TEMPLATE = NAME + " := " + VALUE
    #const ONREADY_CHECKS = "$%" # Skipping get_node for now, since few people use it outside of advanced contexts, but may add it back in with something below
#
    #func _on_replace(context : String, with_name : String) -> void:
        #for ch in ONREADY_CHECKS:
            #if context.contains(ch):
                #return
#
        #var variable_value = TEMPLATE.replace(VALUE, context).replace(NAME, with_name)
#
        ## Go to top of file, find first empty line, insert a line, then insert the variable declaration
        #var idx = 0
#
        #code_editor.text = code_editor.text.replace(context, with_name)
        #
        ## Find closest function going upward by line, insert variable_value into parameter list
        #


class FunctionReplacer extends Replacer:
    const NAME = "#NAME#"
    const VALUE = "#VALUE#"
    const TEMPLATE = "func " + NAME + "():\n" + VALUE # Determine best way to add parameters...will almost certainly require tapping into the parser
    const FUNC_CALL_TEMPLATE = "#NAME#()"
    const PLACEMENT = 6

    func _on_replace(context : String, with_name : String) -> void:
        # Get the new function from the template
        var function_value = TEMPLATE.replace(VALUE, context).replace(NAME, with_name)

        var selection_line = code_editor.get_selection_line(0)
        var indent = code_editor.get_indent_level(selection_line)

        var indenter = " " if code_editor.indent_use_spaces else "\t"
        var indentation = indenter.repeat(indent)

        # replace old value with new function name
        var function_call_value = FUNC_CALL_TEMPLATE.replace(NAME, with_name)
        function_call_value = indentation + function_call_value

        code_editor.text = code_editor.text.replace(context, function_call_value)

        # go to end of file and insert a new line, then the new function
        var file_end = code_editor.get_line_count() - 1
        code_editor.insert_line_at(file_end, "\n")
        file_end += 1
        code_editor.insert_line_at(file_end, function_value)

class RenameReplacer extends Replacer:
    func _on_replace(context : String, with_name : String) -> void:
        code_editor.text = code_editor.text.replace(context, with_name)

class RegionReplacer extends Replacer:
    const REGION_NAME = "#REGION_NAME#"
    const VALUE = "#VALUE#"
    const START_TEMPLATE = "#region " + REGION_NAME + "\n"
    const END_TEMPLATE = "\n#endregion " + REGION_NAME

    func _on_replace(context : String, with_name : String) -> void:
        if context.is_empty():
            var cursor_pos = code_editor.get_caret_line(0)
            code_editor.insert_line_at(cursor_pos, END_TEMPLATE.replace(REGION_NAME, with_name))
            code_editor.insert_line_at(cursor_pos, START_TEMPLATE.replace(REGION_NAME, with_name))
        else:
            code_editor.create_code_region()

