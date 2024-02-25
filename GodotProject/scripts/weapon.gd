class_name Weapon
extends Node2D

@export var bullet_scene: PackedScene
@export var bullet_life_time := 2.0
@export var bullet_speed := 300.0
@export var cool_down := 0.35
@export var is_local := true

var last_time: int

###

func is_shooting() -> bool:
	return last_time > Time.get_ticks_msec()

func shoot(target: Vector2, by: Node) -> void:
	if is_shooting():
		return
	
	var bullet := bullet_scene.instantiate() as Node2D
	var pos = global_position + Vector2(randf_range(-5.0, 5.0), randf_range(-5.0, 5.0))
	Bullets.inst.shoot(bullet, pos, bullet_speed, bullet_life_time, target, by, is_local)
	
	last_time = Time.get_ticks_msec() + int(cool_down * 1000.0)
