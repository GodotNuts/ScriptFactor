class_name DragControl
extends Control

signal drag_started()
signal needs_data(data : Dictionary)
signal drag_canceled()

@export var texture : Texture2D

const DragPreviewScene = preload("res://toolkit/nodes/drag_drop/drag_preview.tscn")

var current_data : Dictionary

static var DragContext := { }

func _get_drag_data(at_position: Vector2) -> Variant:
	var drag_scene = DragPreviewScene.instantiate()
	drag_scene.texture = texture
	
	set_drag_preview(drag_scene)
	drag_scene.global_position = at_position
	current_data = {}
	needs_data.emit(current_data)
	DragControl.DragContext["Data"] = current_data
	DragControl.DragContext["Node"] = self
	drag_started.emit()
	return current_data

func _notification(what: int) -> void:
	if DragContext.has("Node") and DragContext.Node == self:
		if what == NOTIFICATION_DRAG_END:
			if not is_drag_successful():
				drag_canceled.emit()
		elif what == NOTIFICATION_DRAG_BEGIN:
			pass
