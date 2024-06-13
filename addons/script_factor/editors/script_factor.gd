@tool
extends PopupMenu

var plugin

var Shortcuts = {
}

var ShorterShortcuts = {
}

var SubitemShortcuts = {
}

func set_plugin(to_object) -> void:
    plugin = to_object
    plugin.show_at.connect(func(pos) -> void:
        position = pos
        show()
    )

func get_script_editor() -> ScriptEditor:
    return EditorInterface.get_script_editor()

func get_code_editor() -> CodeEdit:
    return get_script_editor().get_current_editor().get_base_editor() as CodeEdit

func _input(event: InputEvent) -> void:
    if event is InputEventKey and visible and event.keycode in Shortcuts.keys():
        show_editor(event.keycode)

func add_editor_shortcut(shortcut : Key, editor_title : String) -> void:
    var child_count = get_child_count()
    ShorterShortcuts[child_count] = shortcut
    add_item(editor_title, child_count, shortcut)

func _on_id_pressed(id: int) -> void:
    if SubitemShortcuts.has(id):
        pass
    else:
        show_editor(ShorterShortcuts[id])

func show_editor(keycode : Key) -> void:
    hide()
    if Shortcuts.has(keycode):
        var editor = Shortcuts[keycode]
        editor.show_at(position, get_code_editor())
