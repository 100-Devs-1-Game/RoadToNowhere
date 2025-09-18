class_name PlaceTileState
extends StateMachineState

var tile_to_place: PlaceableTile
var tile_sprite:= Sprite2D.new()


func _ready() -> void:
	add_child(tile_sprite)
	tile_sprite.hide()


func on_enter():
	update_sprite_texture()


func on_exit():
	tile_sprite.hide()


func on_process(delta: float) -> void:
	var city: City= Global.city
	var tile: Vector2i= city.get_mouse_tile()
	if not city.is_in_bounds(tile):
		tile_sprite.hide()
		return
	
	tile_sprite.position= city.get_position_from_tile(tile)
	tile_sprite.show()


func on_unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				var city: City= Global.city
				city.place_tile(tile_to_place, city.get_mouse_tile())
				finished.emit()


func update_sprite_texture():
	tile_sprite.texture= tile_to_place.card_icon
