@tool
extends Popup
class_name ItemExtractor

var line_edit : LineEdit:
	get:
		return $LineEdit

var code_editor : CodeEdit
var context : String

var validation : Validators.Validator
var replacer : Replacers.Replacer


var handles_empty_context = func() -> bool: return false

func setup(validator : Validators.Validator, replace : Replacers.Replacer, placeholder_text : String) -> void:
	if validator == null or replace == null:
		return

	validation = validator
	replacer = replace
	line_edit.placeholder_text = placeholder_text

func show_at(pos : Vector2, for_editor : CodeEdit) -> void:
	if line_edit != null:
		line_edit.text = ""

	context = for_editor.get_selected_text(0)
	code_editor = for_editor
	position = pos
	show()
	line_edit.grab_focus()
	print("Grabbed focus?")

func _input(event: InputEvent) -> void:
	# It will be visible far less often than an event is an input event key
	if visible and event is InputEventKey and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
		complete()

func complete() -> void:
	if code_editor == null or context.is_empty():
		hide()
		if not handles_empty_context.call():
			print("Does not handle empty context")
			return

	var new_name = line_edit.text
	if not validate(new_name):
		return

	replace(new_name)
	hide()

func validate(var_name : String) -> bool:
	return validation.validate(var_name)

func replace(with_name : String) -> void:
	replacer.replace(code_editor, context, with_name)
