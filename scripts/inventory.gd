extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	#looks for an existing item 
	var itemSlot = slots.filter(func(slot): return slot.item == item && slot.amount < item.maxAmountInStack)
	
	if !itemSlot.is_empty():
		#"filter" wants to return a list (I know there should be only one)
		itemSlot[0].amount += 1
	else:
		#looks for an empty slot to set the item
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		#If there is any space
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	
	updated.emit()
