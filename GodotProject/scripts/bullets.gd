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

func shoot(node: Node2D, velocity: Vector2, life_time: float, by: Node) -> void:
	if node.get_parent() == null: add_child(node, true)
	node.rotation = atan2(velocity.y, velocity.x)
	var bullet := node as Bullet
	bullet.velocity = velocity
	bullet.life_time = life_time
	bullet.by = by
	_bullets.append(bullet)
