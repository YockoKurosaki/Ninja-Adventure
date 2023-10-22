extends CharacterBody2D

# The encapsulate "export" allows me to edit this variable also from the inspector
@export var speed: int = 40 
@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtTimer = $hurtTimer
@onready var hurtBox = $hurtBox
@onready var weapon = $weapon

signal healthChanged
@export var maxHealth: int = 3
@onready var currentHealth: int = maxHealth
@export var knockbackPower: int = 500

@export var inventory: Inventory

var isHurt: bool = false
var canCollectItem = null
var lastAnimDirection:String = "down"
var isAttacking: bool = false

func _ready():
	weapon.visible = false
	effects.play("RESET")

func handleInput():
	# 1. Get movement direction from input
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# 2. Set velocity to movement direction * speed
	velocity = moveDirection*speed
	
	#Collect item
	if Input.is_action_just_pressed("pick_up"):
		if canCollectItem != null:
			canCollectItem.collect(inventory)
	
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	animations.play("attack_" + lastAnimDirection)
	isAttacking = true
	weapon.visible = true
	await animations.animation_finished
	isAttacking = false
	weapon.visible = false
	
func updateAnimation():
	if isAttacking: return
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
		lastAnimDirection = direction

# This is a built in function like the Update in Unity but also related to physics
func _physics_process(_delta):
	handleInput()
	# 3. Move player
	move_and_slide() #This is a built in function that the tutorial decided to use instead move_and_collide
	updateAnimation()
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)

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

func knockback(enemyVelocity):
	var knockbackDirection = (enemyVelocity-velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		canCollectItem = area

func _on_hurt_box_area_exited(area):
	canCollectItem = null
