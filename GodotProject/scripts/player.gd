class_name Player
extends CharacterBody2D

@export var walk_speed := 100.0
@export var weapon: Weapon

@export var max_health := 10
@export var effect_hurt: PackedScene
@export var effect_die: PackedScene

var _input_move: Vector2
var dead := false
var _anim_suffix := "f"

@onready var health := max_health
@onready var animation_player: AnimationPlayer = $Graphics/AnimationPlayer
@onready var sprite: Sprite2D = $Graphics/Sprite

###

func _ready() -> void:
	Events.HURT.register_for(self, _on_hurt)

func _process(delta: float) -> void:
	if dead:
		sprite.rotation_degrees += delta * 360.0
		sprite.modulate = sprite.modulate.lerp(Color.BLACK, delta * 2)
	else:
		if Input.is_action_pressed("shoot"):
			weapon.shoot(get_global_mouse_position(), self)

func _physics_process(delta: float) -> void:
	if dead:
		_input_move = Vector2.ZERO
		animation_player.stop()
	elif Input.is_action_pressed("shoot") or weapon.is_shooting():
		_input_move = Vector2.ZERO
		animation_player.play("shoot_" + _anim_suffix)
	else:
		_input_move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if not Level.cur.check(global_position + Vector2.UP * 5.0, 5.0):
			dead = true
		var anim := "idle_" if not _input_move else "walk_"
		if _input_move.y > 0.0 or (_input_move.y == 0.0 and _input_move.x != 0): _anim_suffix = "f"
		elif _input_move.y < 0.0: _anim_suffix = "b"
		animation_player.play(anim + _anim_suffix)
	
	velocity = _input_move * walk_speed

	if not dead and velocity:
		move_and_slide()

###

func get_target_global_pos() -> Vector2:
	return sprite.global_position

func die(source: Node) -> void:
	dead = true
	
	if effect_die != null:
		var die_effect := effect_die.instantiate() as Node2D
		Game.inst.add_child(die_effect, true)
		die_effect.global_position = global_position

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
