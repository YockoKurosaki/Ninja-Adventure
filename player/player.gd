extends CharacterBody2D

# The encapsulate "export" allows me to edit this variable also from the inspector
@export var speed: int = 40 


func handleInput():
	# 1. Get movement direction from input
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# 2. Set velocity to movement direction * speed
	velocity = moveDirection*speed
	
# This is a built in function like the Update in Unity but also related to physics
func _physics_process(delta):
	handleInput()
	# 3. Move player
	move_and_slide() #This is a built in function that the tutorial decided to use instead move_and_collide

