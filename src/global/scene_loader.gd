extends Node

@export var level_scene: PackedScene
@export var campaign_view: PackedScene
@export var deck_builder: PackedScene
@export var main_menu: PackedScene

var level_data: LevelData



func play_level(_level_data: LevelData):
	level_data= _level_data
	get_tree().change_scene_to_packed(level_scene)


func enter_campaign():
	if not Player.is_deck_perfect_size():
		build_deck()
	else:
		get_tree().change_scene_to_packed(campaign_view)
	

func build_deck():
	get_tree().change_scene_to_packed(deck_builder)


func enter_main_menu():
	get_tree().change_scene_to_packed(main_menu)
