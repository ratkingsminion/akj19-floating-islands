class_name Debug

static var cur_color := Color.WHITE

###

static func set_color(color: Color) -> void:
	cur_color = color

static func draw_cube(node: Node, time: float, pos: Vector3, basis := Basis()) -> Draw3D:
	var d3d := Draw3D.new()
	node.get_tree().current_scene.add_child(d3d)
	d3d.cube(pos, basis, cur_color)
	if time < 0.01: Helpers.do_next_frame(node, func(): d3d.queue_free())
	else: Tweens.timer(node, time, func(): d3d.queue_free())
	return d3d

static func draw_ray(node: Node, time: float, pos: Vector3, dir: Vector3) -> Draw3D:
	var d3d := Draw3D.new()
	node.get_tree().current_scene.add_child(d3d)
	d3d.draw_line([ pos, pos + dir ], cur_color)
	if time < 0.01: Helpers.do_next_frame(node, func(): d3d.queue_free())
	else: Tweens.timer(node, time, func(): d3d.queue_free())
	return d3d
