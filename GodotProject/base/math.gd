class_name Math

### randomness

static func rnd_np() -> int:
	return -1 if randf() < 0.5 else 1

### numbers

static func repeat(t, length):
	return t - floor(t / length) * length

static func repeati(t: int, length: int) -> int:
	return t - floori(t / float(length)) * length

static func repeatf(t: float, length: float) -> float:
	return t - floorf(t / length) * length

static func repeati_array(t: int, array: Array) -> int:
	if array.is_empty(): return 0
	return t - floor(t / float(array.size())) * array.size()

### directions

static func get_right(node: Node3D) -> Vector3:
	return node.get_global_transform().basis.x

static func get_left(node: Node3D) -> Vector3:
	return -node.get_global_transform().basis.x

static func get_up(node: Node3D) -> Vector3:
	return node.get_global_transform().basis.y

static func get_down(node: Node3D) -> Vector3:
	return -node.get_global_transform().basis.y

static func get_forward(node: Node3D) -> Vector3:
	return -node.get_global_transform().basis.z

static func get_back(node: Node3D) -> Vector3:
	return node.get_global_transform().basis.z
	
### vectors

static func vec3_lerp(a: Vector3, b: Vector3, t: Vector3) -> Vector3:
	return Vector3(lerpf(a.x, b.x, t.x), lerpf(a.y, b.y, t.y), lerpf(a.z, b.z, t.z))

static func vec3_with_x(vec: Vector3, x: float) -> Vector3:
	return Vector3(x, vec.y, vec.z)

static func vec3_with_y(vec: Vector3, y: float) -> Vector3:
	return Vector3(vec.x, y, vec.z)

static func vec3_with_z(vec: Vector3, z: float) -> Vector3:
	return Vector3(vec.x, vec.y, z)

static func vec3_add_x(vec: Vector3, x: float) -> Vector3:
	return Vector3(vec.x + x, vec.y, vec.z)

static func vec3_add_y(vec: Vector3, y: float) -> Vector3:
	return Vector3(vec.x, vec.y + y, vec.z)

static func vec3_add_z(vec: Vector3, z: float) -> Vector3:
	return Vector3(vec.x, vec.y, vec.z + z)
