extends Control

@export var initial_scene: StringName = &""
@export var start_button: Button


func _ready() -> void:
	print("MAIN SCENE READY")
	#start_button.pressed.connect(_on_start_button_pressed)

func _on_exit_button_pressed() -> void:
	DevGlobalUtils.ExitGame()
	
func _on_start_button_pressed() -> void:
	SceneManager.load_scene(initial_scene)
