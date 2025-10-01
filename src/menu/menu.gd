extends PanelContainer

@onready var settings_container: GridContainer = %"GridContainer Settings"
@onready var tile_map: TileMapLayer = %TileMapLayer



func _ready() -> void:
	var rect:= tile_map.get_used_rect()
	for x in rect.size.x:
		for y in rect.size.y:
			var tile:= Vector2i(x, y) + rect.position
			tile_map.set_cell(tile, randi_range(0, 5), Vector2i.ZERO)
	
	await get_tree().process_frame
	for child: Control in settings_container.get_children():
		if child is Label:
			continue
		child.scale*= 4


func _on_button_start_pressed() -> void:
	SceneLoader.enter_campaign()


func _on_button_reset_pressed() -> void:
	AudioManager.play_sound("click")
	SaveManager.delete_save_file()


func _on_h_slider_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_check_box_music_toggled(toggled_on: bool) -> void:
	AudioManager.play_sound("click")
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), not toggled_on)
