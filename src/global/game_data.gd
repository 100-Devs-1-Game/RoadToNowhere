extends Node

@export_dir var buildings_tiles_dir
@export_dir var ground_tiles_dir
@export_dir var road_tiles_dir

var source_id_to_building_tile: Dictionary
var source_id_to_ground_tile: Dictionary
var source_id_to_road_tile: Dictionary



func _ready() -> void:
	build_tile_dict(buildings_tiles_dir, source_id_to_building_tile)
	build_tile_dict(ground_tiles_dir, source_id_to_ground_tile)
	build_tile_dict(road_tiles_dir, source_id_to_road_tile)


func build_tile_dict(dir: String, dict: Dictionary):
	for file in ResourceLoader.list_directory(dir):
		var tile: BaseTile= load(dir + "/" + file)
		dict[tile.source_id]= tile
