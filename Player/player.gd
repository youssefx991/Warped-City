extends CharacterBody2D


const SPEED = 170.0
const JUMP_VELOCITY = -450.0

@onready var animated_sprite_2d = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# player animations
var is_crouching = false
var is_shooting = false
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction (input_axis) and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_axis = Input.get_axis("ui_left", "ui_right")
	if input_axis:
		velocity.x = input_axis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Player Crouching
	if Input.is_action_pressed("ui_down") and is_on_floor():
		is_crouching = true
	if Input.is_action_just_released("ui_down"):
		is_crouching = false
	
	# Player Shooting
	if Input.is_action_pressed("shoot") and is_on_floor() and not is_crouching:
		is_shooting = true
	if Input.is_action_just_released("shoot"):
		is_shooting = false	
	
	move_and_slide()
	update_animations(input_axis)
	reset_player_position()

func update_animations(input_axis):
	
	if input_axis > 0:
		animated_sprite_2d.flip_h = false
	elif input_axis < 0:
		animated_sprite_2d.flip_h = true
	if  is_on_floor():
		if is_crouching:
			animated_sprite_2d.play("crouch")	
		elif is_shooting:
			animated_sprite_2d.play("shoot")
		elif input_axis != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		if velocity.y > 0:
			animated_sprite_2d.play("fall")
		else:
			animated_sprite_2d.play("jump")
	
func shoot_bullet():
	pass
func reset_player_position():
	# used only for demonstration purposes.
	if global_position.y > 500:
		global_position = Vector2(100, 100)