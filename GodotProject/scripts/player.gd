class_name Player
extends CharacterBody2D

@export var walk_speed := 100.0
@export var weapon: Weapon

@export var max_health := 7
@export var effect_hurt: PackedScene
@export var effect_die: PackedScene

var _input_move: Vector2
var _anim_suffix := "f"
var health: int

@onready var animation_player: AnimationPlayer = $Graphics/AnimationPlayer
@onready var sprite: Sprite2D = $Graphics/Sprite

###

func _ready() -> void:
	Events.HURT.register_for(self, _on_hurt)
	max_health = max_health + Game.inst._cur_level - 1
	health = max_health

func _process(delta: float) -> void:
	if Game.inst.wait: return
	
	if health <= 0:
		sprite.rotation_degrees += delta * 360.0
		sprite.modulate = sprite.modulate.lerp(Color.BLACK, delta * 2)
	else:
		if Input.is_action_pressed("shoot"):
			if weapon.shoot(get_global_mouse_position(), self):
				Game.inst.audio.play_at_pos_2d("player_shoot", global_position)

func _physics_process(delta: float) -> void:
	if Game.inst.wait: return
	
	if health <= 0:
		_input_move = Vector2.ZERO
		animation_player.stop()
	elif Input.is_action_pressed("shoot") or weapon.is_shooting():
		_input_move = Vector2.ZERO
		animation_player.play("shoot_" + _anim_suffix)
	else:
		_input_move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if not Level.cur.check(global_position + Vector2.UP * 5.0, 5.0):
			die(self)
		var anim := "idle_" if not _input_move else "walk_"
		if _input_move.y > 0.0 or (_input_move.y == 0.0 and _input_move.x != 0): _anim_suffix = "f"
		elif _input_move.y < 0.0: _anim_suffix = "b"
		animation_player.play(anim + _anim_suffix)
	
	velocity = _input_move * walk_speed

	if health > 0 and velocity:
		move_and_slide()
		Game.inst.audio.play_at_pos_2d("player_walk", global_position, 0.25)

###

func get_target_global_pos() -> Vector2:
	return sprite.global_position

func die(source: Node) -> void:
	if health <= 0: return
	health = 0
	
	if source != self and effect_die != null:
		var die_effect := effect_die.instantiate() as Node2D
		Game.inst.add_child(die_effect, true)
		die_effect.global_position = global_position
	
	Game.inst.audio.play_at_pos_2d("player_die", global_position)
	Events.PLAYER_DIED.emit()

### events

func _on_hurt(source: Node) -> void:
	if source == self: return
		
	if source is Bullet:
		source.destroy()
		
		if health == 1:
			die(source)
		elif health > 0:
			if effect_hurt != null:
				var hurt_effect := effect_hurt.instantiate() as Node2D
				Game.inst.add_child(hurt_effect, true)
				hurt_effect.global_position = source.global_position
			
			Tweens.do_01(self, 0.35, func(f: float) -> void:
				sprite.modulate = Color.CRIMSON.lerp(Color.WHITE, f)
			)
		
			health -= 1
			if health > 0: Game.inst.audio.play_at_pos_2d("player_hurt", global_position)
		
