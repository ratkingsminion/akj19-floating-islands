class_name Level
extends Node2D

static var cur: Level

@export var floor_gfx: Texture2D
@export var tile_size := 64.0
@export var tile_count := 20
@export var rotation_speed := 50.0
@export var float_frequency := 5.0
@export var float_amplitude = 2.0

var top: Node2D
var bottom: Node2D
var tile_gfx_size: int
var tile_scale: float
var map: Dictionary # Vector2->Node
var _float_time: float

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
	
	bottom.global_position = top.global_position + Vector2.DOWN * 20.0

###

func get_random_global_pos() -> Vector2:
	if map.size() > 0:
		var pos := map.keys().pick_random() as Vector2i
		return to_global(pos * tile_size)
	return Vector2.ZERO

func check(global_pos: Vector2, radius := 10.0) -> bool:
	var local_pos := to_local(global_pos)
	var rect := Rect2(0, 0, tile_size, tile_size)
		
	for key in map:
		var sprite := map[key] as Sprite2D
		rect.position.x = sprite.position.x - tile_size * 0.5
		rect.position.y = sprite.position.y - tile_size * 0.5
		var delta_x := local_pos.x - maxf(rect.position.x, minf(local_pos.x, rect.position.x + rect.size.x))
		var delta_y := local_pos.y - maxf(rect.position.y, minf(local_pos.y, rect.position.y + rect.size.y))
		if (delta_x * delta_x + delta_y * delta_y) < (radius * radius): return true
	return false

###

func generate_island(reset := true) -> void:
	var dirs: Array[Vector2i] = [ Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN ]
	
	if reset:
		if top != null: top.queue_free()
		map.clear()
		top = Node2D.new()
		$Tiles.add_child(top)
	if bottom != null: bottom.queue_free()
	
	for i in tile_count:
		var key := Vector2i.ZERO
		while map.has(key):
			var nk: Vector2i = map.keys().pick_random() # key
			key = nk + dirs.pick_random()
		var sprite := Sprite2D.new()
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.texture = floor_gfx
		sprite.modulate = Color.YELLOW_GREEN.lerp(Color.AQUAMARINE, randf())
		top.add_child(sprite)
		sprite.position = key * tile_size
		map[key] = sprite
	
	# set graphics
	for key in map:
		var sprite := map[key] as Sprite2D
		sprite.scale = Vector2.ONE * tile_scale
		var i := 0
		if map.has(key + Vector2i.UP): i += 1
		if map.has(key + Vector2i.RIGHT): i += 2
		if map.has(key + Vector2i.DOWN): i += 4
		if map.has(key + Vector2i.LEFT): i += 8
		sprite.region_enabled = true
		sprite.region_rect = Rect2((i % 8) * tile_gfx_size, (i / 8) * tile_gfx_size, tile_gfx_size, tile_gfx_size)
		#print(sprite.region_rect)

	bottom = top.duplicate()
	$Tiles.add_child(bottom)
	$Tiles.move_child(bottom, 0)
	for c in bottom.get_children():
		var sprite := c as Sprite2D
		sprite.modulate = Color.BLACK
