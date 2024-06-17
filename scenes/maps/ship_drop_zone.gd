extends Control

var _has_character : bool

func _ready() -> void:
	set_process(false)
	
	$DropArea.drop_requested.connect(
		func(request : DropArea.DropRequest):
			if not _has_character:
				set_process(true)
				var steps = request.data.map.get_astar_path(request.data.map_position, position)
				request.can_drop = steps.size() <= request.data.player_movement and not _has_character
	)
	
	$DropArea.data_dropped.connect(
		func(data, at_position):
			_has_character = true
	)
	
