extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.is_in_group("Player"):
		print("Player in ladder")
		if area.is_climbing == false:
			area.is_climbing = true
		print("is climbing = " , area.is_climbing)


func _on_area_exited(area):
	if area.is_in_group("Player"):
		print("Player out of ladder")
		if area.is_climbing == true:
			area.is_climbing = false
