class_name Game
extends Node2D

static var inst: Game

@export var _player_scene: PackedScene
@export var _enemy_scenes: Array[PackedScene]
@export var _portal_scene: PackedScene

var _follow_graphics: Dictionary
var _cur_player: Player

var _cur_tile_count := 8
var _cur_enemy_count := 0
var _all_chars := []

@onready var level: Level = $Level
@onready var _player_cam: PlayerCam = $"PlayerCam"
@onready var _graphics: Node2D = $"GRAPHICS"

###

func _ready() -> void:
	Helpers.set_tree(get_tree())
	inst = self
	
	Events.PLAYER_ENTERED_PORTAL.register(_on_player_enter_portal)
	Events.ENEMY_DIED.register(_on_enemy_died)
	
	await get_tree().process_frame
	create_island(_cur_tile_count, 0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		create_island(_cur_tile_count)
		#if Input.is_key_pressed(KEY_SHIFT):
			#level.generate_island(5, false)
			#spawn_portal()
		#else:
			#_cur_tile_count += 1
			#level.generate_island(_cur_tile_count)
			#spawn_player()
			#for i in randi_range(0, 2):
				#spawn_enemy(randi_range(0, _enemy_scenes.size() - 1))
	
	for key in _follow_graphics.keys():
		var node := key as Node2D
		var follow = _follow_graphics[key]
		if not is_instance_valid(follow):
			_follow_graphics.erase(key)
			key.queue_free()
			continue
		node.global_position = (follow as Node2D).global_position

###

func create_island(tile_count: int, force_enemy_count := -1) -> void:
	level.generate_island(tile_count)
	_cur_tile_count = tile_count
	
	_cur_enemy_count = 0
	_all_chars.clear()
	
	await get_tree().process_frame
	
	spawn_player()
	
	var min_count := tile_count / 4 - 1
	var max_count := tile_count / 4 + 1
	_cur_enemy_count = force_enemy_count if force_enemy_count >= 0 else randi_range(min_count, max_count)
	print("create island with ", _cur_enemy_count)
	for i in _cur_enemy_count:
		spawn_enemy(randi_range(0, _enemy_scenes.size() - 1))
	
	if _cur_enemy_count == 0:
		spawn_portal.call_deferred()

func spawn_player() -> void:
	if _cur_player != null:
		_cur_player.queue_free()
	_cur_player = _player_scene.instantiate() as Player
	level.chars.add_child(_cur_player, true)
	
	_cur_player.global_position = level.get_outskirt_global_pos()
	_cur_player.global_rotation = 0.0
	
	_player_cam.follow = _cur_player
	_all_chars.push_back(_cur_player)

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
	var portal := _portal_scene.instantiate() as Portal
	level.chars.add_child(portal, true)
	
	var pos := level.get_outskirt_global_pos()
	for i in 100:
		if min_dist_to_chars(pos) > level.tile_size: break
		pos = level.get_outskirt_global_pos()
	
	if min_dist_to_chars(pos) <= level.tile_size:
		pos = level.get_random_global_pos()
		for i in 100:
			if min_dist_to_chars(pos) > level.tile_size: break
			pos = level.get_random_global_pos()
		
	portal.global_position = pos
	portal.global_rotation = 0.0
	
	_all_chars.push_back(portal)

func min_dist_to_chars(global_pos: Vector2) -> float:
	var smallest := 10000000000.0
	for c in level.chars.get_children():
		var dist: float = global_pos.distance_to(c.global_position)
		if dist < smallest: smallest = dist
	return smallest

func register_graphics(node: Node2D, follow: Node2D) -> void:
	node.reparent(_graphics, true)
	_follow_graphics[node] = follow

### events

func _on_player_enter_portal() -> void:
	_cur_tile_count += 2
	create_island(_cur_tile_count)

func _on_enemy_died(enemy: Enemy) -> void:
	_all_chars.erase(enemy)
	_cur_enemy_count -= 1
	if _cur_enemy_count == 0:
		spawn_portal.call_deferred()
