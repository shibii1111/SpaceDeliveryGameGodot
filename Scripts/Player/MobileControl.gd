extends CanvasLayer

func _ready() -> void:
	SceneManager.mobile_ui_should_show.connect(_on_show_mobile_ui)

func _on_show_mobile_ui() -> void:
	visible = true
