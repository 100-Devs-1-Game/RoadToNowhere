class_name ActionExcavate
extends BaseAction

@export var grass_tile: FloorTile
@export var swamp_tile: FloorTile
@export var rubble_tile: ObjectTile



func can_execute(tile_pos: Vector2i)-> bool:
	if Global.city.has_blocking_dynamic_object(tile_pos):
		return false
	var object: ObjectTile= Global.city.get_object(tile_pos)
	var floor: FloorTile= Global.city.get_floor_tile(tile_pos)
	return object == rubble_tile or floor == swamp_tile


func execute(tile_pos: Vector2i):
	var city: City= Global.city
	if tile_pos in city.get_object_tiles():
		city.remove_tile(tile_pos, City.TileLayer.OBJECTS)
	else:
		city.place_tile(grass_tile, tile_pos)
