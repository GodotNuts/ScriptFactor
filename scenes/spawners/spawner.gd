extends Marker2D

@export var Spawnables : Array[String]

func _process(delta: float) -> void:
	_place_random_spawn()
	set_process(false)
	queue_free()
	
func _place_random_spawn() -> void:
	var random_spawn = Spawnables.pick_random()
	var spawn = load(random_spawn)
	get_tree().current_scene.add_child(spawn)
	spawn.global_position = global_position
