class_name PlayerCam
extends Camera2D

@export var follow: Node2D
@export var lerp_speed := 10.0

###

func _physics_process(delta: float) -> void:
	if follow != null:
		global_position = global_position.lerp(follow.global_position, lerp_speed * delta)
