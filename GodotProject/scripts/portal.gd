class_name Portal
extends Node2D

@onready var animation_player: AnimationPlayer = $Graphics/AnimationPlayer
@onready var sprite: Sprite2D = $Graphics/Sprite

###

func _ready() -> void:
	animation_player.play("portal")
	Events.HURT.register_for(self, _on_hurt)

### events

func _on_hurt(source: Node) -> void:
	if source == self: return
		
	if source is Bullet:
		Tweens.do_01(self, 0.35, func(f: float) -> void:
			sprite.modulate = Color.CRIMSON.lerp(Color.WHITE, f)
		)
		source.destroy()
	elif source is Player:
		Game.inst.audio.play_at_pos_2d("portal", global_position)
		Events.PLAYER_ENTERED_PORTAL.emit()
