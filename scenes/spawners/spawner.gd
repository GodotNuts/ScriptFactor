extends Marker2D

@export var FacingDirection : Vector2i
@export var Spawnables : Array[String]

const ChanceToSpawn = .5

func _process(delta: float) -> void:
	_place_random_spawn()
	set_process(false)
	queue_free()
	
func _place_random_spawn() -> void:
	if randf() > ChanceToSpawn:
		var random_spawn = Spawnables.pick_random()
		var spawn = load(random_spawn).instantiate()
		get_tree().current_scene.add_child(spawn)
		spawn.global_position = global_position
		spawn.scale.y = FacingDirection.y
