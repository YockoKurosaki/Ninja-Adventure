extends Area2D

@export var itemRes: InventoryItem

func collect(inventory: Inventory):
	var done = inventory.insert(itemRes)
	if done:
		queue_free()
