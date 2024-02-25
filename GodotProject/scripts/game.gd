class_name Game
extends Node2D

static var inst: Game

@export var _player_scene: PackedScene
@export var _enemy_scenes: Array[PackedScene]
@export var _portal_scene: PackedScene
@export var _info_label: RichTextLabel
@export var _title_screen: Control
@export var _tile_count_increase_per_level := 3
@export var _tile_count_at_start := 7
@export var _rotation_increase_per_level := 3.0
@export var _rotation_max := 60.0

var _follow_graphics: Dictionary
var _cur_player: Player
var _cur_portal: Portal
var wait := true

var _cur_level := 0
var _cur_enemy_count := 0
var _all_chars := []

@onready var _cur_tile_count := _tile_count_at_start
@onready var level: Level = $Level
@onready var _player_cam: PlayerCam = $"PlayerCam"
@onready var _graphics: Node2D = $"GRAPHICS"
@onready var audio: CompAudioIndexer = $CompAudioIndexer
@onready var music: CompAudioIndexer = $"Music CompAudioIndexer"


###

func _ready() -> void:
	Helpers.set_tree(get_tree())
	inst = self
	
	Events.PLAYER_ENTERED_PORTAL.register(_on_player_enter_portal)
	Events.ENEMY_DIED.register(_on_enemy_died)
	Events.PLAYER_DIED.register(_on_player_died)
	
	await get_tree().process_frame
	create_island(_cur_tile_count)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		_cur_level = 0
		create_island(_tile_count_at_start)
	
	for key in _follow_graphics.keys():
		var node := key as Node2D
		var follow = _follow_graphics[key]
		if not is_instance_valid(follow):
			_follow_graphics.erase(key)
			key.queue_free()
			continue
		node.global_position = (follow as Node2D).global_position

###

func create_island(tile_count: int) -> void:
	wait = true
	_cur_level += 1
	
	if _cur_level == 1: level.rotation_degrees = 0.0
	else: level.rotation_degrees = randf_range(0.0, 360.0)
	level.rotation_speed = max(_cur_level - 2, 0) * _rotation_increase_per_level * Math.rnd_np()
	if level.rotation_speed > _rotation_max: level.rotation_speed = _rotation_max
	
	level.generate_island(tile_count)
	_cur_tile_count = tile_count
	
	_cur_enemy_count = 0
	_all_chars.clear()
	
	await get_tree().process_frame
	
	spawn_player()
	
	if _cur_level == 1:
		_cur_enemy_count = 0
		music.music_fade_out()
	elif _cur_level == 2:
		_cur_enemy_count = 1
		music.music_fade_in("dizzy_01")
		if is_instance_valid(_title_screen):
			_title_screen.queue_free()
	else:
		var min_count := tile_count / 6 - 1
		var max_count := tile_count / 4 - 1
		_cur_enemy_count = randi_range(min_count, max_count)
		music.music_fade_in("dizzy_01")
	
	print("create island with ", _cur_tile_count, " tiles and ", _cur_enemy_count, " enemies")
	
	for i in _cur_enemy_count:
		spawn_enemy(randi_range(0, _enemy_scenes.size() - 1))
	
	if _cur_enemy_count == 0:
		spawn_portal.call_deferred()
	_update_label()
	
	await get_tree().process_frame
	wait = false

func spawn_player() -> void:
	if _cur_player != null:
		_cur_player.queue_free()
	
	_cur_player = _player_scene.instantiate() as Player
	level.chars.add_child(_cur_player, true)
	
	_cur_player.global_position = level.get_outskirt_global_pos()
	_cur_player.global_rotation = 0.0
	
	_player_cam.follow = _cur_player
	_all_chars.push_back(_cur_player)
	
	Events.HURT.register_for(_cur_player, _on_player_hurt)

func spawn_enemy(idx: int) -> void:
	var enemy := _enemy_scenes[idx].instantiate() as Enemy
	level.chars.add_child(enemy, true)
	
	var pos := level.get_random_global_pos()
	for i in 100:
		if min_dist_to_chars(pos) > level.tile_size: break
		pos = level.get_random_global_pos()
	enemy.global_position = pos
	enemy.global_rotation = 0.0
	
	_all_chars.push_back(enemy)

func spawn_portal() -> void:
	_cur_portal = _portal_scene.instantiate() as Portal
	level.chars.add_child(_cur_portal, true)
	
	var pos := level.get_outskirt_global_pos()
	for i in 100:
		if min_dist_to_chars(pos) > level.tile_size: break
		pos = level.get_outskirt_global_pos()
	
	if min_dist_to_chars(pos) <= level.tile_size:
		pos = level.get_random_global_pos()
		for i in 100:
			if min_dist_to_chars(pos) > level.tile_size: break
			pos = level.get_random_global_pos()
		
	_cur_portal.global_position = pos
	_cur_portal.global_rotation = 0.0
	
	_all_chars.push_back(_cur_portal)
	_update_label()

func min_dist_to_chars(global_pos: Vector2) -> float:
	var smallest := 10000000000.0
	for c in level.chars.get_children():
		var dist: float = global_pos.distance_to(c.global_position)
		if dist < smallest: smallest = dist
	return smallest

func register_graphics(node: Node2D, follow: Node2D) -> void:
	node.reparent(_graphics, true)
	_follow_graphics[node] = follow

###

func _update_label() -> void:
	_info_label.text = str("[center]LEVEL ", _cur_level)
	if _cur_player != null:
		var health := maxi(_cur_player.health, 0)
		_info_label.text += str("\nHEALTH ", health, " / ", _cur_player.max_health)
	if _cur_player == null or _cur_player.health <= 0:
		_info_label.text += "\n\nPRESS R TO RESTART"
	elif _cur_level == 1:
		_info_label.text += "\n\nGO TO PORTAL (WASD / CURSOR KEYS)"
	elif _cur_portal != null:
		_info_label.text += "\n\nGO TO PORTAL"
	elif _cur_level == 2:
		_info_label.text += "\n\nSHOOT WITH MOUSE CLICK"
	_info_label.text += "[/center]"

### events

func _on_player_enter_portal() -> void:
	create_island(_cur_tile_count + _tile_count_increase_per_level)

func _on_player_hurt(source: Node) -> void:
	_update_label()

func _on_enemy_died(enemy: Enemy) -> void:
	_all_chars.erase(enemy)
	_cur_enemy_count -= 1
	if _cur_enemy_count == 0:
		spawn_portal.call_deferred()

func _on_player_died() -> void:
	music.music_fade_out()
	_update_label()
