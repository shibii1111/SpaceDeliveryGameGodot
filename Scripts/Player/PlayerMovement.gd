extends CharacterBody2D

@export var move_speed : float = 500.0
@export var friction : float = 100.0
	
func _physics_process(delta: float) -> void:
	var move_dir := Input.get_vector("left", "right", "up", "down")
	
	velocity = move_dir * move_speed
	move_and_slide()	

	if Input.is_action_pressed("fire"):
		look_at(get_global_mouse_position())
	elif move_dir != Vector2.ZERO:
		rotation = move_dir.angle()
