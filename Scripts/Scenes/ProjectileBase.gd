extends Area2D

@export var stats: ProjectileStats

var _origin_scene: PackedScene
var _velocity: Vector2 = Vector2.ZERO
var _life_left: float = 0.0

func _physics_process(delta: float) -> void:
	global_position += _velocity * delta
	
	_life_left -= delta
	if _life_left <= 0.0:
		despawn()

func _set_origin(scene: PackedScene) -> void:
	_origin_scene = scene

func despawn() -> void:
	if _origin_scene == null:
		push_error("Projectile has no origin scene assigned.")
		return
		
	ProjectilePool.give_back(_origin_scene, self)

func activate(direction: Vector2) -> void:
	if stats == null:
		push_error("ProjectileBase: stats is not assigned.")
		return
		
	_velocity = direction.normalized() * stats.speed
	_life_left = stats.lifetime
	
	visible = true
	set_physics_process(true)
	
	monitoring = true
	monitorable = true
	
func deactivate() -> void:
	monitoring = false
	monitorable = false
	
	set_physics_process(false)
	visible = false
