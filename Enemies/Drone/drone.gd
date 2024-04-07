extends Area2D

var direction = -1
var speed = 80

@onready var bullet = preload("res://Bullet/bullet.tscn")
#(30, 10)	(-30, 10)
@onready var bullet_position = $bullet_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x += speed * delta * direction
	
	
func turn_around():
	direction *= -1


func _on_area_entered(area):
	if area.is_in_group("Bullet"):
		queue_free()
