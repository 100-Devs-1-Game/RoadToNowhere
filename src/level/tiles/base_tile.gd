class_name BaseTile
extends Resource

enum CustomScoringAlgorithm { NONE, PARKING, FACTORY, CAR }

@export var name: String
@export_multiline var description: String
@export var target_tilemap: City.TileLayer
@export var source_id: int

@export var custom_scoring: CustomScoringAlgorithm



func run_custom_scoring(state: ScoringPhaseState, tile: Vector2i):
	var city: City= Global.city
	
	match custom_scoring:
		CustomScoringAlgorithm.PARKING:
			for pos in Utils.get_neighbor_tiles(tile, true):
				var ctr:= 0
				if pos in city.get_building_tiles():
					ctr+= 1
				if ctr > 0:
					state.trigger_score(tile, ctr)
					await state.get_tree().create_timer(state.SCORE_DISPLAY_INTERVAL).timeout

		CustomScoringAlgorithm.CAR:
			if tile in city.get_road_tiles():
				state.trigger_score(tile, 2)
				await state.get_tree().create_timer(state.SCORE_DISPLAY_INTERVAL).timeout

		CustomScoringAlgorithm.FACTORY:
			var score: int= 0
			for network in state.road_networks:
				if network.has_building(tile):
					for building_tile in network.buildings:
						var building: BuildingTile= city.get_building(building_tile)
						if building.has_workers:
							score+= 5

			if score > 0:
				state.trigger_score(tile, score)
				await state.get_tree().create_timer(state.SCORE_DISPLAY_INTERVAL).timeout
