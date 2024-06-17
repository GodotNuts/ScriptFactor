extends Node2D

@onready var _sprite = $Sprite2D

@export var enemy_hp : int

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	var rand_chance = randi() % 2
	if rand_chance == 0:
		take_damage(1, Types.WeaponType.Bullet)

func _on_area_2d_area_entered(area: Area2D) -> void:
	take_damage(area.damage, area.weapon_type)
	
func take_damage(damage : int, weapon_type : Types.WeaponType) -> void:
	if enemy_hp - damage <= 0:
		SpecialEffects.add_waitable_effect(preload("res://scenes/special_fx/texture_explosion.tscn").instantiate(), _sprite)
		_sprite.hide()
