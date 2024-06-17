@tool
extends EditorPlugin

const script_path = "res://addons/replacement_drag/drag_drop/"

func _enter_tree() -> void:
	add_custom_type("DragControl", script_path + "drag_control.gd", preload(script_path + "drag_control.gd"), null)
	add_custom_type("DropArea", script_path + "drop_area.gd", preload(script_path + "drop_area.gd"), null)

func _exit_tree() -> void:
	remove_custom_type("DragControl")
	remove_custom_type("DropArea")
