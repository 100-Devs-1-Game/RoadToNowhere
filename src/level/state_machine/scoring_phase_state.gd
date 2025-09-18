class_name ScoringPhaseState
extends StateMachineState



func on_enter():
	var city: City= Global.city
	var tilemap: TileMapLayer= city.get_tilemap(City.TileLayer.ROADS)
	var origin: Vector2= tilemap.get_global_transform_with_canvas().origin
	origin.y-= 20

	var road_dict: Dictionary
	for tile in tilemap.get_used_cells():
		FloatingText.add(origin + city.get_position_from_tile(tile), "+1", 2.0, Color.GREEN, 30, false, true)
		for x in range(-1, 2):
			for y in range(-1, 2):
				var pos:= tile + Vector2i(x, y)
				road_dict[pos]= true
				
		await get_tree().create_timer(0.5).timeout


	tilemap= city.get_tilemap(City.TileLayer.BUILDINGS)
	for tile in tilemap.get_used_cells():
		if road_dict.has(tile):
			FloatingText.add(origin + city.get_position_from_tile(tile), "+5", 2.0, Color.GREEN, 30, false, true)
		await get_tree().create_timer(0.5).timeout
