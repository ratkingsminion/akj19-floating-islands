class_name Enemy
extends CharacterBody2D

@export var walk_speed := 0.0
@export var weapon: Weapon
@export var max_health := 5
@export var effect_hurt: PackedScene
@export var effect_die: PackedScene

var life_timer := 0.0
var dead := false

@onready var health := max_health
@onready var animation_player: AnimationPlayer = $Graphics/AnimationPlayer
@onready var sprite: Sprite2D = $Graphics/Sprite
@onready var _shoot_start := randf_range(1.0, 2.0)

###

func _ready() -> void:
	Events.HURT.register_for(self, _on_hurt)
	animation_player.play(&"idle")

func _process(delta: float) -> void:
	life_timer += delta
	if life_timer > _shoot_start and weapon != null and Game.inst._cur_player != null:
		weapon.shoot(Game.inst._cur_player.get_target_global_pos(), self)

###

func die(source: Node) -> void:
	if effect_die != null:
		var die_effect := effect_die.instantiate() as Node2D
		Game.inst.add_child(die_effect, true)
		die_effect.global_position = global_position
	
	queue_free()

### events

func _on_hurt(source: Node) -> void:
	if source == self: return
		
	if source is Bullet:
		if effect_hurt != null:
			var hurt_effect := effect_hurt.instantiate() as Node2D
			Game.inst.add_child(hurt_effect, true)
			hurt_effect.global_position = source.global_position
		
		Tweens.do_01(self, 0.35, func(f: float) -> void:
			modulate = Color.CRIMSON.lerp(Color.WHITE, f)
		)
	
		source.destroy()
		health -= 1
		
	if health <= 0:
		die(source)
