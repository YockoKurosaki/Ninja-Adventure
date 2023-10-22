extends Node2D

@onready var heartContainer = $CanvasLayer/heartsContainer
@onready var player = $Player

func _ready():
	heartContainer.setMaxHearts(player.maxHealth)
	heartContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartContainer.updateHearts)

func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true
