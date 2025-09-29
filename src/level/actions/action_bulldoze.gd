class_name ActionBulldoze
extends BaseAction

@export var rubble_tile: ObjectTile



func can_execute(tile_pos: Vector2i)-> bool:
	var building: BuildingTile= Global.city.get_building(tile_pos)
	if building:
		return true
	return tile_pos in Global.city.get_object_tiles()


func execute(tile_pos: Vector2i):
	var building: BuildingTile= Global.city.get_building(tile_pos)
	if building:
		Global.city.remove_tile(tile_pos, City.TileLayer.BUILDINGS)
		Global.city.place_tile(rubble_tile, tile_pos)
	else:
		Global.city.remove_tile(tile_pos, City.TileLayer.OBJECTS)
