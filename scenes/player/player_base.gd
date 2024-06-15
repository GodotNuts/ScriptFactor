extends Node2D

@onready var _anim = $AnimationPlayer
@onready var _sprite = $Sprite2D
@onready var _damage = $Area2D/CollisionShape2D

func take_damage(amount : float, weapon_type : Types.WeaponType) -> void:
	_anim.stop(true)
	SpecialEffects.shake(_sprite, 1.2)
