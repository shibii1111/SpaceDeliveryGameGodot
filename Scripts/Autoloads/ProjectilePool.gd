extends Node

var _pools: Dictionary = {}

@export var default_warm_count: int = 0

func _get_pool(scene: PackedScene) -> Array:
	if not _pools.has(scene):
		_pools[scene] = []
	return _pools[scene]
	
func take(scene: PackedScene) -> Node:
	var pool := _get_pool(scene)
	if pool.size() > 0:
		return pool.pop_back()
		
	return scene.instantiate()
	
func give_back(scene: PackedScene, instance: Node) -> void:
	if instance.get_parent() != null:
		instance.get_parent().remove_child(instance)
		
	if instance.has_method("deactivate"):
		instance.deactivate()
		
	var pool := _get_pool(scene)
	pool.push_back(instance)

func take_projectile(scene: PackedScene) -> Area2D:
	var instance: Area2D
	var pool := _get_pool(scene)
	
	if pool.size() > 0:
		instance = pool.pop_back()
	else:
		instance = scene.instantiate()
		
	if instance.has_method("_set_origin"):
		instance._set_origin(scene)
	else:
		push_error("Pooled scene root must implement _set_origin(scene)")
		
	return instance
