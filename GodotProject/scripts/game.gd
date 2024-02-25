class_name Game
extends Node2D

static var inst: Game

@export var _player_scene: PackedScene
@export var _enemy_scenes: Array[PackedScene]

var _follow_graphics: Dictionary
var _cur_player:Player

@onready var level: Level = $Level
@onready var _player_cam: PlayerCam = $"PlayerCam"
@onready var _graphics: Node2D = $"GRAPHICS"
@onready var _chars: Node2D = $Level/CHARS

###

func _ready() -> void:
	Helpers.set_tree(get_tree())
	inst = self
	
	await get_tree().process_frame
	level.generate_island()
	spawn_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		if Input.is_action_just_pressed("restart") and Input.is_key_pressed(KEY_SHIFT):
			level.generate_island(false)
		elif Input.is_action_just_pressed("restart"):
			for c in _chars.get_children(): c.queue_free()
			level.generate_island()
			spawn_player()
			for i in randi_range(0, 2):
				spawn_enemy(randi_range(0, _enemy_scenes.size() - 1))
	
	for key in _follow_graphics.keys():
		var node := key as Node2D
		var follow = _follow_graphics[key]
		if not is_instance_valid(follow):
			_follow_graphics.erase(key)
			key.queue_free()
			continue
		node.global_position = (follow as Node2D).global_position

###

func spawn_player() -> void:
	if _cur_player != null:
		_cur_player.queue_free()
	_cur_player = _player_scene.instantiate() as Player
	_chars.add_child(_cur_player, true)
	
	_cur_player.global_position = level.global_position
	_cur_player.global_rotation = 0.0
	
	_player_cam.follow = _cur_player

func spawn_enemy(idx: int) -> void:
	var enemy := _enemy_scenes[idx].instantiate() as Enemy
	_chars.add_child(enemy, true)
	
	enemy.global_position = level.get_random_global_pos()
	enemy.global_rotation = 0.0

func register_graphics(node: Node2D, follow: Node2D) -> void:
	node.reparent(_graphics, true)
	_follow_graphics[node] = follow
