extends Node

signal progress_changed(progress: float)
signal load_finished
signal mobile_ui_should_show

var loading_screen: PackedScene = Constants.Scenes.LOADING_SCREEN
var loaded_resource: PackedScene
var scene_path: String
var progress: Array = []
var use_sub_thread: bool = true

@export var level_container_path: NodePath = NodePath("/root/Main/Level")

func _ready() -> void:
	set_process(false)

func load_scene(_scene_path: String) -> void:
	scene_path = _scene_path

	var new_load_screen = loading_screen.instantiate()
	add_child(new_load_screen)
	
	var mobile_control := get_tree().get_first_node_in_group("MobileControl") as CanvasLayer
	if mobile_control != null:
		mobile_control.visible = false

	progress_changed.connect(new_load_screen._on_progress_changed)
	load_finished.connect(new_load_screen._on_load_finished)

	await new_load_screen.loading_screen_ready
	start_load()

func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_thread)
	if state == OK:
		set_process(true)

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	
	if progress.size() > 0:
		var percent: float = progress[0] * 100.0
		progress_changed.emit(percent)

	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)

		ResourceLoader.THREAD_LOAD_LOADED:
			set_process(false)
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			
			var level_instance := _swap_into_level_container_and_return(loaded_resource)
			await get_tree().process_frame
			
			_refresh_player_spawn()

			await get_tree().process_frame
			mobile_ui_should_show.emit()
			load_finished.emit()

func _swap_into_level_container_and_return(packed: PackedScene) -> Node:
	var container: Node = get_node(level_container_path)
	
	# Remove old level
	for child in container.get_children():
		child.queue_free()

	# Add new level
	var level_instance = packed.instantiate()
	container.add_child(level_instance)
	
	return level_instance
	
func _refresh_player_spawn() -> void:
	var player := get_tree().get_first_node_in_group("Player") as Node2D
	var spawn := get_tree().get_first_node_in_group("SpawnPoints") as Node2D
	var camera := get_tree().get_first_node_in_group("Camera") as Node2D
	
	if player == null:
		push_warning("No player found in group 'Player'")
		return
	if spawn == null:
		push_warning("No spawn points found in group 'SpawnPoints'")
		return
		
	player.global_position = spawn.global_position
	camera.set_enabled(true)
