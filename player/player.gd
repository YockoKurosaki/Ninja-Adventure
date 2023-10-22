extends CharacterBody2D

# The encapsulate "export" allows me to edit this variable also from the inspector
@export var speed: int = 40 
@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtTimer = $hurtTimer

signal healthChanged
@export var maxHealth: int = 3
@onready var currentHealth: int = maxHealth

@export var knockbackPower: int = 500

var isHurt: bool = false
var enemyCollisions = []

func _ready():
	effects.play("RESET")

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
	if !isHurt:
		for enemyArea in enemyCollisions:
			hurtByEnemy(enemyArea)

func hurtByEnemy(area):
	if currentHealth > 0:
		currentHealth -= 1;
		
		isHurt = true
		healthChanged.emit(currentHealth)
		knockback(area.get_parent().velocity)
		effects.play("hurt_blink")
		hurtTimer.start()
		await hurtTimer.timeout
		effects.play("RESET")
		isHurt = false

func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		enemyCollisions.append(area)

func knockback(enemyVelocity):
	var knockbackDirection = (enemyVelocity-velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()


func _on_hurt_box_area_exited(area):
	enemyCollisions.erase(area)
