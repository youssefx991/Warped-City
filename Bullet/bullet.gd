extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var direction = Vector2.ZERO
var speed = 600

# who is shooting
var shooter = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += speed * delta * direction
