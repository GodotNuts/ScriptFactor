extends Effect

@onready var _explosion = $ExplosionScene

func _ready() -> void:
	_explosion.animation_finished.connect(_on_animation_finished)

func start_effect(parent_node) -> void:
	_explosion.play()
	
func _on_animation_finished() -> void:
	effect_completed.emit()
	
