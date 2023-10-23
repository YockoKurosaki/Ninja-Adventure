extends Area2D

@onready var shape = $CollisionShape2D

func enabled(active: bool):
	shape.disabled = !active
