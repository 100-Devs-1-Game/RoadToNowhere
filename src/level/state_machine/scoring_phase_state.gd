class_name ScoringPhaseState
extends StateMachineState



func on_enter():
	score_city()


func score_city():
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
		
		for connection: Vector2i in city.get_road_connections(tile):
			var connected_road_pos: Vector2i= tile + connection
			if connected_road_pos not in tilemap.get_used_cells() or -connection not in city.get_road_connections(connected_road_pos):
				FloatingText.add(origin + city.get_position_from_tile(tile) + Vector2(connection) * 32, "-1", 2.0, Color.RED, 30, false, true)
					
		
		await get_tree().create_timer(0.5).timeout


	tilemap= city.get_tilemap(City.TileLayer.BUILDINGS)
	for tile in tilemap.get_used_cells():
		if road_dict.has(tile):
			FloatingText.add(origin + city.get_position_from_tile(tile), "+5", 2.0, Color.GREEN, 30, false, true)
		await get_tree().create_timer(0.5).timeout


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventKey:
		if event.keycode == KEY_F1:
			score_city()
