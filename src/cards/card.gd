class_name Card
extends PanelContainer

signal discard

@export var default_texture: Texture2D

@onready var title: Label = %Title
@onready var texture_rect: TextureRect = %TextureRect


var data: CardData


func init(_data: CardData):
	data= _data
	title.text= data.get_display_name()
	if data.unlocked:
		texture_rect.texture= data.get_icon()
	else:
		texture_rect.texture= default_texture


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_MASK_LEFT:
				discard.emit()
