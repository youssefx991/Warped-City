extends CharacterBody2D

var health = 100
signal say_health(health)

const SPEED = 170.0
const JUMP_VELOCITY = -450.0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var bullet = preload("res://Bullet/bullet.tscn")
@onready var bullet_position = $bullet_position
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# player animations
var is_crouching = false
var is_shooting = false
var is_climbing = false
var is_hurt = false

var bullet_direction = 0

func _ready():
	say_health.emit(health)
func _physics_process(delta):
	
	
	if is_climbing:
		velocity.y = 0
		
		if Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED
			animated_sprite_2d.play("climb")
		elif Input.is_action_pressed("ui_down"):
			velocity.y = SPEED
			animated_sprite_2d.play("climb")
		else:
			animated_sprite_2d.stop()
	
	
	# Add the gravity.
	if not is_on_floor() and not is_climbing:
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() :
		velocity.y = JUMP_VELOCITY

	# Get the input direction (input_axis) and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_axis = Input.get_axis("ui_left", "ui_right")
	if input_axis:
		velocity.x = input_axis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# player climbing
	
	# Player Crouching
	if Input.is_action_pressed("ui_down") and is_on_floor():
		is_crouching = true
		bullet_position.position.y = -25
	if Input.is_action_just_released("ui_down"):
		is_crouching = false
		bullet_position.position.y = -42
	
	# Player Shooting
	if Input.is_action_just_pressed("shoot") and velocity.y >= 0:
		is_shooting = true
		shoot_bullet()
	if Input.is_action_just_released("shoot"):
		is_shooting = false	
	
	move_and_slide()
	update_animations(input_axis)
	reset_player_position()

func update_animations(input_axis):
	
	
	if input_axis > 0:
		animated_sprite_2d.flip_h = false
		bullet_direction = 1
		bullet_position.position.x = 27
	elif input_axis < 0:
		animated_sprite_2d.flip_h = true
		bullet_direction = -1
		bullet_position.position.x = -27
		
	if is_hurt:
		animated_sprite_2d.play("hurt")
	elif  is_on_floor():
		if is_crouching:
			animated_sprite_2d.play("crouch")	
		elif is_shooting:
			animated_sprite_2d.play("shoot")
		elif input_axis != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		if is_climbing:
			animated_sprite_2d.play("climb")
		elif velocity.y > 0 or is_shooting:
			animated_sprite_2d.play("fall")
		else:
			animated_sprite_2d.play("jump")
	
func shoot_bullet():
	var current_bullet = bullet.instantiate()
	current_bullet.shooter = "Player"
	current_bullet.direction = Vector2(bullet_direction, 0)
	current_bullet.global_position = bullet_position.global_position
	
	get_parent().add_child(current_bullet)
	
	
func reset_player_position():
	# used only for demonstration purposes.
	if global_position.y > 500:
		global_position = Vector2(100, 100)
		health -= 20
		say_health.emit(health)


func _on_player_area_area_entered(area):
	print("area entered")
	if area.is_in_group("Bullet"):
		print("bullet entered")	
		if area.shooter == "Enemy":
			print("drone bullet entered")
			is_hurt = true
			health -= 10
			say_health.emit(health)


func _on_player_area_area_exited(area):
	if area.is_in_group("Bullet"):
		if area.shooter == "Enemy":
			
			area.queue_free()


func _on_timer_timeout():
	is_hurt = false
