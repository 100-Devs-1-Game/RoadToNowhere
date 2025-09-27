extends Node

@export var level_scene: PackedScene
@export var campaign_view: PackedScene
@export var deck_builder: PackedScene

var level_data: LevelData



func play_level(_level_data: LevelData):
	level_data= _level_data
	get_tree().change_scene_to_packed(level_scene)
