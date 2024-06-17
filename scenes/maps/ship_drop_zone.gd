extends Control

var has_character : bool

func _ready() -> void:
	set_process(false)
	
	$DropArea.drop_requested.connect(
		func(request : DropArea.DropRequest):
			if not has_character and request.data.player.can_move:
				set_process(true)
				var steps = request.data.map.get_astar_path(request.data.map_position, position)
				request.can_drop = steps.size() <= request.data.player_movement and not has_character
	)
	
	$DropArea.data_dropped.connect(
		func(data : Dictionary, at_position):
			if data.player.ship_drop_zone != null:
				data.player.ship_drop_zone.has_character = false
				
			has_character = true
			data.player.move_to(position, self)
			data.player.show_sprite()
	)
	
