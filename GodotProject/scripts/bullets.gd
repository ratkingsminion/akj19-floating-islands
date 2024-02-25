class_name Bullets
extends Node2D

static var inst: Bullets

var _bullets: Array[Bullet]

###

func _ready() -> void:
	inst = self
	
func _physics_process(delta: float) -> void:
	for i in range(_bullets.size() - 1, -1, -1):
		var bullet := _bullets[i]
		if not is_instance_valid(bullet):
			_bullets.remove_at(i)
			continue
		bullet.position += bullet.velocity * delta
		bullet.life_time -= delta
		if bullet.life_time <= 0.0:
			bullet.destroy()
			_bullets.remove_at(i)

###

func shoot(node: Node2D, speed: float, life_time: float, target: Vector2, by: Node, local: bool) -> void:
	var parent := node.get_parent()
	if parent == null:
		if local: parent = Game.inst.level.bullets_local
		else: parent = self
		parent.add_child(node, true)
	
	var bullet := node as Bullet
	bullet.velocity = speed * (parent.to_local(target) - bullet.position).normalized()
	bullet.rotation = atan2(bullet.velocity.y, bullet.velocity.x)
	bullet.life_time = life_time
	bullet.by = by
	_bullets.append(bullet)
