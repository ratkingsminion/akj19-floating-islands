class_name Level
extends Node2D

static var cur: Level

@export var floor_gfx: Texture2D
@export var tile_size := 64.0
@export var rotation_speed := 50.0
@export var float_frequency := 5.0
@export var float_amplitude = 2.0

var grass: Node2D
var beach: Node2D
var bottom: Node2D
var tile_gfx_size: int
var tile_scale: float
var map: Dictionary # Vector2->Dictionary[beach:Node, grass:Node]
var _float_time: float

@onready var _tiles: Node2D = $TILES
@onready var chars: Node2D = $CHARS
@onready var bullets_local: Node2D = $"BULLETS LOCAL"

###

func _ready() -> void:
	tile_gfx_size = int(floor_gfx.get_size().x) / 8
	tile_scale = tile_size / tile_gfx_size
	print("tile size: ", tile_size, " tile scale: ", tile_scale, " tile gfx size: ", tile_gfx_size)
	cur = self

func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
	
	_float_time += delta
	position = Vector2(0.0, sin(_float_time * float_frequency) * float_amplitude)
	
	bottom.global_position = beach.global_position + Vector2.DOWN * 20.0

###

func get_random_global_pos() -> Vector2:
	if map.size() > 0:
		var pos := map.keys().pick_random() as Vector2i
		return to_global(pos * tile_size)
	return Vector2.ZERO

func get_outskirt_global_pos() -> Vector2:
	var keys := map.keys()
	keys.shuffle()
	var smallest_n := 5
	var pos := keys.back() as Vector2i
	for key in keys:
		var n := map[key]["neighbors"] as int
		if n < smallest_n:
			smallest_n = n
			pos = key
			if n == 1: break
	return to_global(pos * tile_size)

func check(global_pos: Vector2, radius := 10.0) -> bool:
	var local_pos := to_local(global_pos)
	var rect := Rect2(0, 0, tile_size, tile_size)
		
	for key in map:
		var sprite := map[key]["beach"] as Sprite2D
		rect.position.x = sprite.position.x - tile_size * 0.5
		rect.position.y = sprite.position.y - tile_size * 0.5
		var delta_x := local_pos.x - maxf(rect.position.x, minf(local_pos.x, rect.position.x + rect.size.x))
		var delta_y := local_pos.y - maxf(rect.position.y, minf(local_pos.y, rect.position.y + rect.size.y))
		if (delta_x * delta_x + delta_y * delta_y) < (radius * radius): return true
	return false

###

func generate_island(tile_count: int, reset := true) -> void:
	var dirs: Array[Vector2i] = [ Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN ]
	
	if reset:
		for c in chars.get_children(): c.queue_free()
		for c in bullets_local.get_children(): c.queue_free()
		map.clear()
		
		if beach != null: beach.queue_free()
		beach = Node2D.new()
		_tiles.add_child(beach)
		
		if grass != null: grass.queue_free()
		grass = Node2D.new()
		_tiles.add_child(grass)
	if bottom != null: bottom.queue_free()
	
	for i in tile_count:
		var key := Vector2i.ZERO
		while map.has(key):
			var nk: Vector2i = map.keys().pick_random() # key
			key = nk + dirs.pick_random()
		map[key] = {} 
	
	# set graphics
	for key in map:
		var n := 0
		if map.has(key + Vector2i.UP): n += 1
		if map.has(key + Vector2i.RIGHT): n += 1
		if map.has(key + Vector2i.DOWN): n += 1
		if map.has(key + Vector2i.LEFT): n += 1
		map[key]["neighbors"] = n
		
	for key in map:
		var i_beach := 0
		var i_grass := 0
		if map.has(key + Vector2i.UP): i_beach += 1; i_grass += 1 if map[key + Vector2i.UP]["neighbors"] > 3 else 0
		if map.has(key + Vector2i.RIGHT): i_beach += 2; i_grass += 2 if map[key + Vector2i.RIGHT]["neighbors"] > 3 else 0
		if map.has(key + Vector2i.DOWN): i_beach += 4; i_grass += 4 if map[key + Vector2i.DOWN]["neighbors"] > 3 else 0
		if map.has(key + Vector2i.LEFT): i_beach += 8; i_grass += 8 if map[key + Vector2i.LEFT]["neighbors"] > 3 else 0
		
		var sprite_beach := Sprite2D.new()
		sprite_beach.scale = Vector2.ONE * tile_scale
		sprite_beach.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite_beach.texture = floor_gfx
		sprite_beach.position = key * tile_size
		sprite_beach.region_enabled = true
		sprite_beach.region_rect = Rect2((i_beach % 8) * tile_gfx_size, (i_beach / 8) * tile_gfx_size, tile_gfx_size, tile_gfx_size)
		sprite_beach.modulate = Color.BURLYWOOD.lerp(Color.BISQUE, randf())
		beach.add_child(sprite_beach)
		map[key]["beach"] = sprite_beach
		
		if map[key]["neighbors"] > 3:
			var sprite_grass := Sprite2D.new()
			sprite_grass.scale = Vector2.ONE * tile_scale
			sprite_grass.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			sprite_grass.texture = floor_gfx
			sprite_grass.position = key * tile_size
			sprite_grass.region_enabled = true
			sprite_grass.region_rect = Rect2((i_grass % 8) * tile_gfx_size, (i_grass / 8) * tile_gfx_size, tile_gfx_size, tile_gfx_size)
			sprite_grass.modulate = Color.DARK_OLIVE_GREEN.lerp(Color.MEDIUM_SEA_GREEN, randf())
			grass.add_child(sprite_grass)
			map[key]["grass"] = sprite_grass

	bottom = beach.duplicate()
	_tiles.add_child(bottom)
	_tiles.move_child(bottom, 0)
	for c in bottom.get_children():
		var sprite := c as Sprite2D
		sprite.modulate = Color.BLACK
