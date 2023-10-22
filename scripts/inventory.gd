extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]
var done:bool = false

func insert(item: InventoryItem):
	done = false
	#looks for an existing item 
	var itemSlot = slots.filter(func(slot): return slot.item == item && slot.amount < item.maxAmountInStack)
	
	if !itemSlot.is_empty():
		#"filter" wants to return a list (I know there should be only one)
		itemSlot[0].amount += 1
		done = true
	else:
		#looks for an empty slot to set the item
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		#If there is any space
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
			done = true
	
	updated.emit()
	return done
