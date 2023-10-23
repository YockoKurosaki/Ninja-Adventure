extends CharacterBody2D

@export var speed: int = 20
@export var limit = 0.5
@export var endPoint:Marker2D

@onready var animations = $AnimationPlayer

var startPosition
var endPosition
var isDead: bool = false

func _ready():
	startPosition = position
	endPosition = endPoint.global_position

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized()*speed

func updateAnimation():
	var animationString = "walk_up"
	if velocity.y > 0:
		animationString = "walk_down"
	if velocity.x > 0:
		animationString = "walk_right"
	elif velocity.x < 0:
		animationString = "walk_left"
	animations.play(animationString)

func _physics_process(delta):
	if isDead: return
	updateVelocity()
	move_and_slide()
	updateAnimation()

func _on_hit_box_area_entered(area):
	if area.get_parent().name == "weapon":
		$hitBox.set_deferred("monitorable", false) #Deactivates the collision if is dead
		animations.play("death")
		isDead = true
		await animations.animation_finished
		queue_free()
