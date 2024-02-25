class_name Bullet
extends StaticBody2D

var velocity: Vector2
var life_time: float
var by: Node

@onready var _trail: GPUParticles2D = $"Trail GPUParticles2D"

###

func destroy() -> void:
	if is_instance_valid(_trail):
		_trail.emitting = false
		_trail.reparent(get_parent(), true)
	queue_free()
