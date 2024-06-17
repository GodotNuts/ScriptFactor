extends Control

const DragSpeed = 20.0

var position_set := false

@onready var _texture = %TextureRect


var texture : Texture2D:
	set(value):
		var value_size = value.get_size()
		%TextureRect.texture = value # Has to be done without @onready because this can occur and often does before the control is ready
		%TextureRect.size = value_size
	get:
		return %TextureRect.texture

func _process(delta: float) -> void:
	if not position_set:
		position_set = true
		_texture.global_position = global_position	
	
	_texture.global_position = lerp(_texture.global_position, global_position - (texture.get_size() / 2.0), delta * DragSpeed)
	
