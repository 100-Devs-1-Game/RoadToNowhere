class_name ActionFellTree
extends BaseAction

@export var tree_tile: ObjectTile



func can_execute(tile_pos: Vector2i)-> bool:
	if Global.city.has_blocking_dynamic_object(tile_pos):
		return false
	var object: ObjectTile= Global.city.get_object(tile_pos)
	return object == tree_tile


func execute(tile_pos: Vector2i):
	Global.city.remove_tile(tile_pos, City.TileLayer.OBJECTS)
