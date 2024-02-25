extends Node

@export var disable_emit_after := -1.0

var timer: int = 10000000000

###

func _ready() -> void:
	if disable_emit_after >= 0.0:
		await Helpers.tree_timout(disable_emit_after)
		self.emitting = false

func _process(delta: float) -> void:
	if self.emitting:
		timer = Time.get_ticks_msec()
	else:
		if timer + int(self.lifetime * 1000) < Time.get_ticks_msec():
			queue_free()
