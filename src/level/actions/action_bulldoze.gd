class_name ActionBulldoze
extends BaseAction

@export var rubble_tile: ObjectTile



func can_execute(tile_pos: Vector2i)-> bool:
	var building: BuildingTile= Global.city.get_building(tile_pos)
	return building != null


func execute(tile_pos: Vector2i):
	Global.city.remove_building(rubble_tile, tile_pos)
	Global.city.place_tile(rubble_tile, tile_pos)
