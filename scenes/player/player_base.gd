extends Node2D


const ShipSpeed = 30

@onready var _drag = $DragControl
@onready var _sprite = $Sprite2D
@onready var _anim = $AnimationPlayer

var _map : TileMapLayer

@export var Movement : int # Squares that this ship can move

var ship_drop_zone = null
var current_target_position = null
var can_move = true

func take_damage(amount : float, weapon_type : Types.WeaponType) -> void:
	_anim.stop(true)
	SpecialEffects.shake(_sprite, 1.2)

func move_to(pos : Vector2, drop_zone) -> void:
	ship_drop_zone = drop_zone
	current_target_position = pos
	$MoveTimeout.start()
	can_move = false

func show_sprite():
	_sprite.show()

#region Privates, handlers, etc.

func _ready() -> void:
	_map = get_tree().get_first_node_in_group("Navigation")
	_drag.texture = _sprite.texture
	_drag.drag_canceled.connect(_on_drag_control_drag_canceled)
	_drag.drag_started.connect(_on_drag_control_drag_started)
	_drag.needs_data.connect(_on_drag_control_needs_data)

func _physics_process(delta: float) -> void:
	if current_target_position != null:
		var direction = (current_target_position - position).normalized()
		global_position += direction * ShipSpeed * delta
		if global_position.distance_squared_to(current_target_position) < 5.0:
			global_position = current_target_position
			current_target_position = null

func _on_drag_control_drag_started() -> void:	
	_sprite.hide()

func _on_drag_control_drag_canceled() -> void:
	show_sprite()

func _on_drag_control_needs_data(data: Dictionary) -> void:
	data["map_position"] = position
	data["map"] = _map
	data["player_movement"] = Movement
	data["player"] = self

func _on_move_timeout_timeout() -> void:
	can_move = true
	
#endregion
