extends HBoxContainer

@onready var HeartGuiClass = preload("res://scenes/heart_gui.tscn")

func setMaxHearts(max:int):
	for i in range(max):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: int):
	var hearts = get_children()
	#Number of hearts to whole
	for i in range(currentHealth):
		hearts[i].update(true)
	#Number of hearts to empty
	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false)
