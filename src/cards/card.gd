class_name Card
extends PanelContainer

signal discard

@export var default_texture: Texture2D

@onready var title: Label = %Title
@onready var texture_rect: TextureRect = %TextureRect


var tile: PlaceableTile


func init(_tile: PlaceableTile):
	tile= _tile
	if tile:
		title.text= tile.name
		texture_rect.texture= tile.card_icon
	else:
		texture_rect.texture= default_texture


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_MASK_LEFT:
				discard.emit()
