extends Node2D

@export var Movement : int # Squares that this ship can move

var _map : TileMapLayer

func _ready() -> void:
	$DragControl.texture = $Sprite2D.texture
	_map = get_tree().get_first_node_in_group("Navigation")

func take_damage(amount : float, weapon_type : Types.WeaponType) -> void:
	$AnimationPlayer.stop(true)
	SpecialEffects.shake($Sprite2D, 1.2)


func _on_drag_control_drag_started() -> void:
	$Sprite2D.hide()

func _on_drag_control_drag_canceled() -> void:
	$Sprite2D.show()

func _on_drag_control_needs_data(data: Dictionary) -> void:
	data["map_position"] = position
	data["map"] = _map
	data["player_movement"] = Movement
