class_name Wobbler
extends Node

class Wobble:
	var target: Node3D
	var factor := 0.0
	var seconds := 1.0
	var start_seconds := 1.0
	var strength := 1.0
	var max_strength := 1.5
	#public WobbleAnimations.Type type = WobbleAnimations.Type.Scale;
	#public Transform target;
	var original_basis: Basis
	#public Vector3 rotationAxis;
	var start_time := 0.0
	var axis := Vector3.ONE

static var _inst: Wobbler
static var _cur_wobbles: Array[Wobble] = []

###

func _process(delta: float) -> void:
	for idx in range(_cur_wobbles.size() - 1, -1, -1):
		var wobble = _cur_wobbles[idx]
		
		if wobble == null or not is_instance_valid(wobble.target):
			_cur_wobbles.remove_at(idx)
			continue
		
		var time := Helpers.cur_time()
		wobble.seconds -= delta
		var target_factor = clampf(wobble.seconds / wobble.start_seconds, 0.0, 1.0)
		wobble.factor = move_toward(wobble.factor, target_factor, delta * 10.0)
		
		if wobble.factor <= 0.0 and wobble.seconds <= 0.0:
			wobble.target.basis = wobble.original_basis
			_cur_wobbles.remove_at(idx)
			continue
			
		var original_scale: Vector3 = wobble.original_basis.get_scale()
		var scale: Vector3 = original_scale * lerpf(1.0,
			remap(sin(wobble.start_time + time * 20), -1.0, 1.0, lerpf(1.0, 0.75, wobble.strength), lerpf(1.0, 1.5, wobble.strength)),
			wobble.factor)
		wobble.target.scale = Math.vec3_lerp(original_scale, scale, wobble.axis)

static func wobble_y(node: Node3D, strength := 1.0, seconds := 1.0) -> void:
	wobble(node, strength, seconds, Vector3.UP)

static func wobble(node: Node3D, strength := 1.0, seconds := 1.0, axis := Vector3.ONE) -> void:
	if node == null or strength == 0.0 or seconds <= 0.0: 
		return
	
	if _inst == null:
		_inst = Wobbler.new()
		node.get_tree().current_scene.add_child(_inst, true)
	
	var list := _cur_wobbles.filter(func(w: Wobble) -> bool: return w.target == node)
	if not list.is_empty():
		list[0].seconds = seconds
	else:
		var wobble := Wobble.new()
		wobble.factor = 0.0
		wobble.target = node
		wobble.start_seconds = seconds
		wobble.seconds = seconds
		wobble.strength = strength
		wobble.original_basis = node.basis
		wobble.start_time = randf() * PI
		wobble.axis = axis
		_cur_wobbles.append(wobble)
