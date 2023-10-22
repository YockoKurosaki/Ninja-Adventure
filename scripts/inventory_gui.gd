extends Control

signal opened
signal closed

var isOpen: bool = false

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	inventory.updated.connect(update)
	update()

func update():
	#just in case inventory.items.size() and slots.size() are different, take the smaller
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func open():
	isOpen = !isOpen
	visible = isOpen
	if isOpen: opened.emit()
	else: closed.emit()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		open()
