class_name PlaceTileState
extends StateMachineState

var tile_to_place: PlaceableTile
var tile_sprite:= Sprite2D.new()
var can_place_tile: bool= false
var rotation: float= 0.0:
	set(r):
		rotation= r
		tile_sprite.rotation= r
		if tile_to_place.flip_h and is_equal_approx(r, PI):
			tile_sprite.rotation= 0
			tile_sprite.flip_h


func _ready() -> void:
	add_child(tile_sprite)
	tile_sprite.hide()


func on_enter():
	rotation= 0
	update_sprite_texture()


func on_exit():
	tile_sprite.hide()


func on_process(delta: float) -> void:
	var city: City= Global.city
	var tile: Vector2i= city.get_mouse_tile()
	if not city.is_in_bounds(tile):
		tile_sprite.hide()
		can_place_tile= false
		return
	
	tile_sprite.position= city.get_position_from_tile(tile)
	
	can_place_tile= city.can_build_tile_at(tile)
	tile_sprite.modulate= Color.WHITE if can_place_tile else Color.ORANGE_RED

	tile_sprite.show()


func on_unhandled_input(event: InputEvent):
	if not event.is_pressed():
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and can_place_tile:
			var city: City= Global.city
			#prints("TileSprite rotation", tile_sprite.rotation)
			city.place_tile(tile_to_place, city.get_mouse_tile(), rotation)
			finished.emit()
	elif event.is_action("rotate_left") and tile_to_place.can_rotate:
		rotate(-1)
	elif event.is_action("rotate_right") and tile_to_place.can_rotate:
		rotate(1)


func rotate(dir: int):
	rotation+= dir * PI / 2
	#prints("TileSprite rotated", tile_sprite.rotation)


func update_sprite_texture():
	tile_sprite.texture= tile_to_place.card_icon
