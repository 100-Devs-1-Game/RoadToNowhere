class_name ActionBulldoze
extends BaseAction

@export var rubble_tile: ObjectTile
@export var tree_tile: ObjectTile



func can_execute(tile_pos: Vector2i)-> bool:
	if Global.city.has_blocking_dynamic_object(tile_pos):
		return false

	var building: BuildingTile= Global.city.get_building(tile_pos)
	if building:
		return true
	var object: ObjectTile= Global.city.get_object(tile_pos)
	return object == tree_tile


func execute(tile_pos: Vector2i):
	var building: BuildingTile= Global.city.get_building(tile_pos)
	if building:
		Global.city.remove_tile(tile_pos, City.TileLayer.BUILDINGS)
		Global.city.place_tile(rubble_tile, tile_pos)
	else:
		Global.city.remove_tile(tile_pos, City.TileLayer.OBJECTS)
