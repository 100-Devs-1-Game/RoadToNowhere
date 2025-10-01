class_name BaseTile
extends Resource

enum CustomScoringAlgorithm { NONE, PARKING, FACTORY, CAR }

@export var name: String
@export_multiline var description: String
@export var target_tilemap: City.TileLayer
@export var source_id: int

@export var custom_scoring: CustomScoringAlgorithm



func run_custom_scoring(state: ScoringPhaseState, tile: Vector2i, show_text: bool= true)-> int:
	var city: City= Global.city
	var score:= 0
	
	match custom_scoring:
		CustomScoringAlgorithm.PARKING:
			for pos in Utils.get_neighbor_tiles(tile, true):
				if pos in city.get_building_tiles():
					score+= 1

		CustomScoringAlgorithm.CAR:
			if tile in city.get_road_tiles():
				score= 2

		CustomScoringAlgorithm.FACTORY:
			for network in state.road_networks:
				if network.has_building(tile):
					for building_tile in network.buildings:
						var building: BuildingTile= city.get_building(building_tile)
						if building.has_workers:
							score+= 5

	if show_text:
		state.trigger_score(tile, score)
	return score
