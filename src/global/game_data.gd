extends Node

@export_dir var buildings_tiles_dir
@export_dir var ground_tiles_dir
@export_dir var road_tiles_dir
@export_dir var cards_dir

var source_id_to_building_tile: Dictionary
var source_id_to_ground_tile: Dictionary
var source_id_to_road_tile: Dictionary

var card_pool: Array[CardData]



func _ready() -> void:
	build_tile_dict(buildings_tiles_dir, source_id_to_building_tile)
	build_tile_dict(ground_tiles_dir, source_id_to_ground_tile)
	build_tile_dict(road_tiles_dir, source_id_to_road_tile)

	build_card_pool()


func build_tile_dict(dir: String, dict: Dictionary):
	for file in ResourceLoader.list_directory(dir):
		var tile: BaseTile= load(dir + "/" + file)
		dict[tile.source_id]= tile


func build_card_pool():
	for file in ResourceLoader.list_directory(cards_dir):
		card_pool.append(load(cards_dir + "/" + file))
