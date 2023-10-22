extends CharacterBody2D

# The encapsulate "export" allows me to edit this variable also from the inspector
@export var speed: int = 40 
@onready var animations = $AnimationPlayer

signal healthChanged
@export var maxHealth: int = 3
@onready var currentHealth: int = maxHealth

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
func _physics_process(_delta):
	handleInput()
	# 3. Move player
	move_and_slide() #This is a built in function that the tutorial decided to use instead move_and_collide
	updateAnimation()

func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		if currentHealth > 0:
			currentHealth -= 1;
			healthChanged.emit(currentHealth)
