class_name ActionBuildBridge
extends BaseAction

@export var asphalt_tile: FloorTile



func can_execute(tile_pos: Vector2i)-> bool:
	if Global.city.has_blocking_dynamic_object(tile_pos):
		return false

	return Global.city.is_water_tile(tile_pos)


func execute(tile_pos: Vector2i):
	Global.city.place_tile(asphalt_tile, tile_pos)
