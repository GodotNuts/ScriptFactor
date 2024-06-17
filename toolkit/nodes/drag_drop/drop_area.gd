class_name DropArea
extends Control

signal drop_requested(request : DropRequest)
signal data_dropped(value, at_position)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var result = DropRequest.new(data, at_position)
	drop_requested.emit(result)
	return result.can_drop
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	data_dropped.emit(data, at_position)

class DropRequest extends RefCounted:
	var can_drop = false
	var data
	var at_position
	
	func _init(some_data, at_pos):
		data = some_data
		at_position = at_pos
		
