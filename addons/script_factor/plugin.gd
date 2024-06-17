@tool
extends EditorPlugin

var script_factor_plugin

var can_popup := false
var active_script = null
var script_editor
var previous_editor

const DEFAULT_EXTRACTOR = preload("res://addons/script_factor/editors/item_name_interface.tscn")

signal show_at(pos)

func _enter_tree() -> void:
	script_factor_plugin = preload("res://addons/script_factor/editors/script_factor_interface.tscn").instantiate()

	add_child(script_factor_plugin)

	var editor_interface = get_editor_interface()
	script_editor = editor_interface.get_script_editor()
	script_editor.editor_script_changed.connect(_on_editor_changed)

	previous_editor = script_editor.get_current_editor()
	if previous_editor != null and not previous_editor.get_base_editor().gui_input.is_connected(_on_event):
		previous_editor.get_base_editor().gui_input.connect(_on_event)

	_add_editor("ScriptFactorRename", DEFAULT_EXTRACTOR, Validators.NameValidator.new(), Replacers.RenameReplacer.new(), "Rename variable", KEY_1)
	_add_editor("ScriptFactorVariable", DEFAULT_EXTRACTOR, Validators.NameValidator.new(), Replacers.VariableReplacer.new(), "To variable", KEY_2)
	#_add_editor("ScriptFactorParameter", DEFAULT_EXTRACTOR, Validators.NameValidator.new(), Replacers.ParameterReplacer.new(), "To parameter", KEY_3)
	_add_editor("ScriptFactorConstVariable", DEFAULT_EXTRACTOR, Validators.NameValidator.new(), Replacers.ConstReplacer.new(), "To const", KEY_4)
	_add_editor("ScriptFactorFunction", DEFAULT_EXTRACTOR, Validators.NameValidator.new(), Replacers.FunctionReplacer.new(), "To function", KEY_5)
	_add_editor("ScriptFactorRegionize", DEFAULT_EXTRACTOR, Validators.NoValidator.new(), Replacers.RegionReplacer.new(), "Add region", KEY_6, true)

	script_factor_plugin.set_plugin(self)

	main_screen_changed.connect(func(screen_name : String) -> void: # Probably not AOL
		can_popup = screen_name == "Script"
	)

func _add_editor(editor_name : String, item_extractor : PackedScene, validator : Validators.Validator, replacer : Replacers.Replacer, replacer_title : String, shortcut : Key, handles_empty_context : bool = false) -> void:
	var editor = item_extractor.instantiate()
	add_child(editor)
	script_factor_plugin.add_editor_shortcut(shortcut, replacer_title)
	editor.setup(validator, replacer, replacer_title)
	script_factor_plugin.Shortcuts[shortcut] = editor
	editor.handles_empty_context = func() -> bool: return handles_empty_context

func _exit_tree() -> void:
	script_factor_plugin.free()
	script_editor.editor_script_changed.disconnect(_on_editor_changed)

func _on_editor_changed(script : Script) -> void:
	var new_editor = script_editor.get_current_editor()
	if new_editor != previous_editor and previous_editor != null:
		previous_editor.get_base_editor().gui_input.disconnect(_on_event)

	previous_editor = new_editor
	if not previous_editor.get_base_editor().gui_input.is_connected(_on_event):
		previous_editor.get_base_editor().gui_input.connect(_on_event)

func _on_event(ev : InputEvent) -> void:
	if ev is InputEventKey:
		var input = ev as InputEventKey
		if input.alt_pressed and input.keycode == KEY_QUOTELEFT:
			var mouse_pos = get_viewport().get_mouse_position()
			show_at.emit(mouse_pos)
