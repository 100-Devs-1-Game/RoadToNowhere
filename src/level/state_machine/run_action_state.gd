class_name RunActionState
extends StateMachineState

var action: BaseAction
var action_sprite:= Sprite2D.new()
var can_execute: bool= false



func _ready() -> void:
	add_child(action_sprite)
	action_sprite.hide()


func on_enter():
	action_sprite.texture= action.icon
	Global.level.set_description(action.description)


func on_exit():
	action_sprite.hide()


func on_process(delta: float) -> void:
	var city: City= Global.city
	var tile: Vector2i= city.get_mouse_tile()
	if not city.is_in_bounds(tile):
		action_sprite.hide()
		can_execute= false
		return
	
	action_sprite.position= city.get_position_from_tile(tile)

	can_execute= action.can_execute(tile)
	action_sprite.modulate= Color.WHITE if can_execute else Color.ORANGE_RED

	action_sprite.show()


func on_unhandled_input(event: InputEvent):
	if not event.is_pressed():
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and can_execute:
			action.execute(Global.city.get_mouse_tile())
			finished.emit()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			finished.emit()
