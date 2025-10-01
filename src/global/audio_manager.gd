extends Node

@export var sfx_library: SFXLibrary
@export var num_players: int= 3
@export var audio_players: Array[AudioStreamPlayer]

@onready var player_menu_music: AudioStreamPlayer = $"AudioStreamPlayer Menu Music"
@onready var player_level_music: AudioStreamPlayer = $"AudioStreamPlayer Level Music"



func _ready() -> void:
	sfx_library.build()
	for i in num_players - 1:
		var alt_player= audio_players[0].duplicate()
		add_child(alt_player)
		audio_players.append(alt_player)


func play_sound(sound_name: String):
	var sound_item: SFXLibraryItem= sfx_library.get_item(sound_name)
	assert(sound_item)
	var player: AudioStreamPlayer= get_free_player()
	if not player:
		push_warning("No free audio player")
		return
	player.volume_db= 0 + sound_item.db_delta
	player.stream= sound_item.audio_stream
	player.play()


func play_menu_music():
	if player_menu_music.playing:
		return
	player_menu_music.play()


func play_level_music():
	if player_level_music.playing:
		return
	player_level_music.play()


func get_free_player()-> AudioStreamPlayer:
	for player in audio_players:
		if not player.playing:
			return player
	return null
