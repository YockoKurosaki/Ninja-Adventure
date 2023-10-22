extends Camera2D

#We are going to identify the tilemap that is used in the World
@export var tilemap: TileMap

func _ready():
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	#Calculates the world size
	var worldSizeInPixels = mapRect.size * tileSize
	#find the limits
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
