extends Control

signal opened
signal closed

var isOpen: bool = false

func open():
	isOpen = !isOpen
	visible = isOpen
	if isOpen: opened.emit()
	else: closed.emit()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		open()
