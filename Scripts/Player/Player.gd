extends Node2D

@export var projectile_scene: PackedScene
@export var shots_per_second: float = 6.0
@export var max_activate_projectiles: int = 5

@onready var muzzle: Marker2D = $Body/Muzzle
@onready var body: CharacterBody2D = $Body

var _cooldown_left: float = 0.0
var _activate_projectiles: int = 0

var external_fire_pressed: bool = false
var use_external_input: bool = false

func _process(delta: float) -> void:
	_cooldown_left = maxf(0.0, _cooldown_left - delta)
	
	if _is_fire_pressed():
		_try_shoot()
	
func _is_fire_pressed() -> bool:
	if use_external_input:
		return external_fire_pressed	
		
	return Input.is_action_pressed("fire")
	
func _try_shoot() -> void:
	if _cooldown_left > 0.0:
		return
		
	if _activate_projectiles >= max_activate_projectiles:
		return
		
	_shoot()
	_cooldown_left = 1.0 / shots_per_second
	
func _shoot() -> void:
	if projectile_scene == null:
		push_error("Player: projectile_scene is not assigned.")
		return
		
	var projectile = ProjectilePool.take_projectile(projectile_scene)
	get_tree().current_scene.add_child(projectile)
	_activate_projectiles += 1
	
	if not projectile.tree_exited.is_connected(_on_projectile_removed):
		projectile.tree_exited.connect(_on_projectile_removed)
	
	projectile.global_transform = muzzle.global_transform
	
	if projectile.has_method("activate"):
		var dir := Vector2.RIGHT.rotated(muzzle.global_rotation)
		projectile.activate(dir)
		
func _on_projectile_removed() -> void:
	_activate_projectiles = max(0, _activate_projectiles - 1)
