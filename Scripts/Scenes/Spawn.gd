extends Marker2D

func _ready() -> void:
	var player := get_tree().get_first_node_in_group("Player") as Node2D
	var spawn := get_tree().get_first_node_in_group("SpawnPoints") as Node2D
	
	if player == null:
		print("no player found in group")
		return			
	
	if spawn == null:
		print("no spawn found in group")
		return
	else:
		player.global_position = spawn.global_position
		print("Player at: ", player.global_position)
		print("spawn at: ",  spawn.global_position)
