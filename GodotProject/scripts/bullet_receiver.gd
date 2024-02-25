class_name BulletReceiver
extends Area2D

@export var woundable: Node

###

func _ready() -> void:
	body_entered.connect(_on_body_entered)

### events

func _on_body_entered(body: Node2D) -> void:
	if body == woundable: return
	if body is Bullet:
		if (body as Bullet).by == woundable: return
	Events.HURT.emit_to(woundable, body)
