extends Resource

class_name Inventory

signal updated

@export var items: Array[InventoryItem]

func insert(item: InventoryItem):
	#looks for an empty slot to set the item
	for i in range(items.size()):
		if !items[i]:
			items[i] = item
			#Once it found a slot, breaks the loop
			break
	updated.emit()
