class_name Event

## # Example on how to use these classes:
## class_name Events
## static var GAME_STATE_CHANGED := Event.Signal_2.new("old: State", "new: State")
## static var OBJECT_INTERACTED := Event.Targeted_1.new("source:object")
## static var ENEMY_KILLED_BY_PLAYER := Event.Targeted_0.new()
## # Use them like this:
## Events.GAME_STATE_CHANGED.register(func(old_state, new_state): print("switching to ", new_state))
## Events.OBJECT_INTERACTED.emit_to(cur_target, self)
## Events.ENEMY_KILLED_BY_PLAYER.register_for(self, on_killed_by_player)

### helpers

static func _random_id(length) -> StringName:
	var word := ""
	for i in length: word += "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"[randi() % 52]
	return StringName(word)

### normal events, wrapper for Godot's signals

class Signal_0:
	signal _signal()
	
	func _init() -> void:
		pass
	
	func register(callable: Callable) -> void:
		_signal.connect(callable)
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit() -> void:
		_signal.emit()

class Signal_1:
	signal _signal(val)
	var _params: String
	
	func _init(params := "") -> void:
		_params = params
	
	func register(callable: Callable) -> void:
		_signal.connect(callable)
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit(val) -> void:
		_signal.emit(val)

class Signal_2:
	signal _signal(val)
	var _params: String
	
	func _init(params := "") -> void:
		_params = params
	
	func register(callable: Callable) -> void:
		_signal.connect(callable)
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit(val1, val2) -> void:
		_signal.emit(val1, val2)

class Signal_3:
	signal _signal(val)
	var _params: String
	
	func _init(params := "") -> void:
		_params = params
	
	func register(callable: Callable) -> void:
		_signal.connect(callable)
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit(val1, val2, val3) -> void:
		_signal.emit(val1, val2, val3)

### targeted events, wrapping Godot's signals and user signals

class Targeted_0:
	signal _signal(target: Object)
	var _signal_id: StringName
	var _target: String
	var _params: String
	
	func _init(target := "", params = "") -> void:
		_target = target
		_params = params
		_signal_id = Event._random_id(16)
	
	func register_for(target: Object, callable: Callable) -> bool:
		if target == null: return false
		if not target.has_user_signal(_signal_id): target.add_user_signal(_signal_id)
		target.connect(_signal_id, callable)
		return true
	
	func register(callable: Callable) -> void:
		_signal.connect(callable)
	
	func unregister_for(target: Object, callable: Callable) -> bool:
		if target == null: return false
		if not target.has_user_signal(_signal_id): return false
		target.disconnect(_signal_id, callable)
		return true
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit_to(target: Object) -> bool:
		if target != null and target.has_user_signal(_signal_id):
			target.emit_signal(_signal_id)
		_signal.emit(target)
		return true
	
	func is_registered_for(target: Object) -> bool:
		if target == null: return false
		return target.has_user_signal(_signal_id)

class Targeted_1:
	signal _signal(target: Object, val)
	var _signal_id: StringName
	var _target: String
	var _params: String
	
	func _init(target := "", params = "") -> void:
		_target = target
		_params = params
		_signal_id = Event._random_id(16)
	
	func register_for(target: Object, callable: Callable) -> bool:
		if target == null: return false
		if not target.has_user_signal(_signal_id): target.add_user_signal(_signal_id)
		target.connect(_signal_id, callable)
		return true
	
	func register(callable: Callable) -> void:
		_signal.connect(callable)
	
	func unregister_for(target: Object, callable: Callable) -> bool:
		if target == null: return false
		if not target.has_user_signal(_signal_id): return false
		target.disconnect(_signal_id, callable)
		return true
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit_to(target: Object, val) -> bool:
		if target != null and target.has_user_signal(_signal_id):
			target.emit_signal(_signal_id, val)
		_signal.emit(target, val)
		return true
	
	func is_registered_for(target: Object) -> bool:
		if target == null: return false
		return target.has_user_signal(_signal_id)

class Targeted_2:
	signal _signal(target: Object, val1, val2)
	var _signal_id: StringName
	var _target: String
	var _params: String
	
	func _init(target := "", params = "") -> void:
		_target = target
		_params = params
		_signal_id = Event._random_id(16)
	
	func register_for(target: Object, callable: Callable) -> bool:
		if target == null: return false
		if not target.has_user_signal(_signal_id): target.add_user_signal(_signal_id)
		target.connect(_signal_id, callable)
		return true
	
	func register(callable: Callable) -> void:
		_signal.connect(callable)
	
	func unregister_for(target: Object, callable: Callable) -> bool:
		if target == null: return false
		if not target.has_user_signal(_signal_id): return false
		target.disconnect(_signal_id, callable)
		return true
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit_to(target: Object, val1, val2) -> bool:
		if target != null and target.has_user_signal(_signal_id):
			target.emit_signal(_signal_id, val1, val2)
		_signal.emit(target, val1, val2)
		return true
	
	func is_registered_for(target: Object) -> bool:
		if target == null: return false
		return target.has_user_signal(_signal_id)

class Targeted_3:
	signal _signal(target: Object, val1, val2, val3)
	var _signal_id: StringName
	var _target: String
	var _params: String
	
	func _init(target := "", params = "") -> void:
		_target = target
		_params = params
		_signal_id = Event._random_id(16)
	
	func register_for(target: Object, callable: Callable) -> bool:
		if target == null: return false
		if not target.has_user_signal(_signal_id): target.add_user_signal(_signal_id)
		target.connect(_signal_id, callable)
		_signal.connect(callable)
		return true
	
	func register(callable: Callable) -> void:
		_signal.connect(callable)
	
	func unregister_for(target: Object, callable: Callable) -> bool:
		if target == null: return false
		if not target.has_user_signal(_signal_id): return false
		target.disconnect(_signal_id, callable)
		return true
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit_to(target: Object, val1, val2, val3) -> bool:
		if target != null and target.has_user_signal(_signal_id):
			target.emit_signal(_signal_id, val1, val2, val3)
		_signal.emit(target, val1, val2, val3)
		return true
	
	func is_registered_for(target: Object) -> bool:
		if target == null: return false
		return target.has_user_signal(_signal_id)

### string based targeted events

class Targeted_String_0:
	class _TargetedString extends Object:
		var _signal_id: StringName
		
		func _init() -> void:
			_signal_id = Event._random_id(16)
			add_user_signal(_signal_id)
			
		func register(callable: Callable) -> bool:
			if is_connected(_signal_id, callable): return false
			connect(_signal_id, callable)
			return true
			
		func unregister(callable: Callable) -> bool:
			if not is_connected(_signal_id, callable): return false
			disconnect(_signal_id, callable)
			return true
		
		func emit() -> void:
			emit_signal(_signal_id)

	var _targets: Dictionary
	signal _signal(target: StringName)
	var _target: String
	
	func _init(target := "") -> void:
		_target = target
	
	func register_for(target: StringName, callable: Callable) -> bool:
		if target == null: return false
		if not _targets.has(target): _targets[target] = _TargetedString.new()
		return _targets[target].register(callable)
	
	func register(callable: Callable) -> bool:
		_signal.connect(callable)
		return true
	
	func unregister_for(target: StringName, callable: Callable) -> bool:
		if target == null: return false
		if not _targets.has(target): return false
		return _targets[target].disconnect(callable)
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit_to(target: StringName) -> bool:
		if _targets.has(target): _targets[target].emit()
		_signal.emit(target)
		return true
	
	func is_registered_for(target: StringName) -> bool:
		return _targets.has(target)

class Targeted_String_1:
	class _TargetedString extends Object:
		var _signal_id: StringName
		
		func _init() -> void:
			_signal_id = Event._random_id(16)
			add_user_signal(_signal_id)
			
		func register(callable: Callable) -> bool:
			if is_connected(_signal_id, callable): return false
			connect(_signal_id, callable)
			return true
			
		func unregister(callable: Callable) -> bool:
			if not is_connected(_signal_id, callable): return false
			disconnect(_signal_id, callable)
			return true
		
		func emit(val) -> void:
			emit_signal(_signal_id, val)

	var _targets: Dictionary
	signal _signal(target: StringName, val)
	var _target: String
	var _params: String
	
	func _init(target := "", params = "") -> void:
		_target = target
		_params = params
	
	func register_for(target: StringName, callable: Callable) -> bool:
		if target == null: return false
		if not _targets.has(target): _targets[target] = _TargetedString.new()
		return _targets[target].register(callable)
	
	func register(callable: Callable) -> bool:
		_signal.connect(callable)
		return true
	
	func unregister_for(target: StringName, callable: Callable) -> bool:
		if target == null: return false
		if not _targets.has(target): return false
		return _targets[target].disconnect(callable)
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit_to(target: StringName, val) -> bool:
		if _targets.has(target): _targets[target].emit(val)
		_signal.emit(target, val)
		return true
	
	func is_registered_for(target: StringName) -> bool:
		return _targets.has(target)

class Targeted_String_2:
	class _TargetedString extends Object:
		var _signal_id: StringName
		
		func _init() -> void:
			_signal_id = Event._random_id(16)
			add_user_signal(_signal_id)
			
		func register(callable: Callable) -> bool:
			if is_connected(_signal_id, callable): return false
			connect(_signal_id, callable)
			return true
			
		func unregister(callable: Callable) -> bool:
			if not is_connected(_signal_id, callable): return false
			disconnect(_signal_id, callable)
			return true
		
		func emit(val1, val2) -> void:
			emit_signal(_signal_id, val1, val2)

	var _targets: Dictionary
	signal _signal(target: StringName, val1, val2)
	var _target: String
	var _params: String
	
	func _init(target := "", params = "") -> void:
		_target = target
		_params = params
	
	func register_for(target: StringName, callable: Callable) -> bool:
		if target == null: return false
		if not _targets.has(target): _targets[target] = _TargetedString.new()
		return _targets[target].register(callable)
	
	func register(callable: Callable) -> bool:
		_signal.connect(callable)
		return true
	
	func unregister_for(target: StringName, callable: Callable) -> bool:
		if target == null: return false
		if not _targets.has(target): return false
		return _targets[target].disconnect(callable)
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit_to(target: StringName, val1, val2) -> bool:
		if _targets.has(target): _targets[target].emit(val1, val2)
		_signal.emit(target, val1, val2)
		return true
	
	func is_registered_for(target: StringName) -> bool:
		return _targets.has(target)

class Targeted_String_3:
	class _TargetedString extends Object:
		var _signal_id: StringName
		
		func _init() -> void:
			_signal_id = Event._random_id(16)
			add_user_signal(_signal_id)
			
		func register(callable: Callable) -> bool:
			if is_connected(_signal_id, callable): return false
			connect(_signal_id, callable)
			return true
			
		func unregister(callable: Callable) -> bool:
			if not is_connected(_signal_id, callable): return false
			disconnect(_signal_id, callable)
			return true
		
		func emit(val1, val2, val3) -> void:
			emit_signal(_signal_id, val1, val2, val3)

	var _targets: Dictionary
	signal _signal(target: StringName, val1, val2, val3)
	var _target: String
	var _params: String
	
	func _init(target := "", params = "") -> void:
		_target = target
		_params = params
	
	func register_for(target: StringName, callable: Callable) -> bool:
		if target == null: return false
		if not _targets.has(target): _targets[target] = _TargetedString.new()
		return _targets[target].register(callable)
	
	func register(callable: Callable) -> bool:
		_signal.connect(callable)
		return true
	
	func unregister_for(target: StringName, callable: Callable) -> bool:
		if target == null: return false
		if not _targets.has(target): return false
		return _targets[target].disconnect(callable)
	
	func unregister(callable: Callable) -> bool:
		if not _signal.is_connected(callable): return false
		_signal.disconnect(callable)
		return true

	func emit_to(target: StringName, val1, val2, val3) -> bool:
		if _targets.has(target): _targets[target].emit(val1, val2, val3)
		_signal.emit(target, val1, val2, val3)
		return true
	
	func is_registered_for(target: StringName) -> bool:
		return _targets.has(target)
