extends RefCounted
class_name FreeAwaitable

# A special class designed to free a target after a specific signal triggers exactly once

var target

func _init(free_target, sig : Signal):
	target = free_target
	sig.connect(func(): target.queue_free(), CONNECT_ONE_SHOT)
