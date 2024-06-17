extends TileMapLayer

var astar = AStarGrid2D.new()

func _ready() -> void:
	astar.cell_size = Vector2(16, 16)
	astar.region = Rect2i(0, 0, 20, 11)
	astar.update()

func get_astar_path(pos1 : Vector2, pos2 : Vector2) -> Array:
	var pos1_conv = local_to_map(pos1)
	var pos2_conv = local_to_map(pos2)
	return astar.get_point_path(pos1_conv, pos2_conv)
