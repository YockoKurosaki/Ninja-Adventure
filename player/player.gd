extends CharacterBody2D

# The encapsulate "export" allows me to edit this variable also from the inspector
@export var speed: int = 40 
@onready var animations = $AnimationPlayer


func handleInput():
	# 1. Get movement direction from input
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# 2. Set velocity to movement direction * speed
	velocity = moveDirection*speed
	
func updateAnimation():
	# If is not moving
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "down"
		# Validate in which direction is moving the character to select the correct animation
		if velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
		animations.play("walk_" + direction)
	

# This is a built in function like the Update in Unity but also related to physics
func _physics_process(delta):
	handleInput()
	# 3. Move player
	move_and_slide() #This is a built in function that the tutorial decided to use instead move_and_collide
	updateAnimation()

