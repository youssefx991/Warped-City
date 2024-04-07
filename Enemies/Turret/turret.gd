extends Area2D

@onready var bullet = preload("res://Bullet/bullet.tscn")
#(15, -8)	(-15, -8)
@onready var bullet_position = $bullet_position
# Called every frame. 'delta' is the elapsed time since the previous frame.

# when player enters drone area
var found_near_player = false
var near_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.is_in_group("Bullet"):
		if area.shooter == "Player":
			queue_free()


func _on_shoot_area_area_entered(area):
	if area.is_in_group("Player"):
		found_near_player = true
		near_player = area
		
func shoot_at(player):
	var current_bullet = bullet.instantiate()
	current_bullet.shooter = "Enemy"
	current_bullet.direction = Vector2(player,0) 
	current_bullet.global_position = bullet_position.global_position
	get_parent().add_child(current_bullet)
	#print("SHOOOOOOOOOOOOOOOOting")


func _on_shoot_area_area_exited(area):
	if area.is_in_group("Player"):
		found_near_player = false
		near_player = null


func _on_timer_timeout():
	if found_near_player:
		handle_near_player(near_player)
		
func handle_near_player(area):
	if area.global_position.x > global_position.x: # drone <-> player
		
			bullet_position.position.x = 30
			shoot_at(1)
	elif area.global_position.x < global_position.x: # player <-> drone
		
			bullet_position.position.x = -30
			shoot_at(-1)
