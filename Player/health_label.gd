extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_say_health(health):
	if health <= 0:
		get_tree().change_scene_to_file("res://Wasted_Menu/wasted_menu.tscn")
	else:
		text = str(health)
