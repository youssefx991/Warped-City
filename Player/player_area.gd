extends Area2D

var player_position = Vector2.ZERO
var is_climbing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_position = $"..".global_position
	#is_climbing = $"..".is_climbing
	$"..".is_climbing = is_climbing
