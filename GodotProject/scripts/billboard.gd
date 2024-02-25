extends Node2D

###

func _ready() -> void:
	await get_tree().process_frame
	Game.inst.register_graphics(self, get_parent())

#func _process(delta: float) -> void:
#	global_rotation = 0.0
