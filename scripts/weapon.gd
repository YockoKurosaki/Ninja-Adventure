extends Node2D

var weapon: Area2D

func _ready():
	if get_children().is_empty(): return
	
	weapon = get_children()[0]

func enabled(active: bool):
	if !weapon: return
	visible = active
	weapon.enabled(active)
