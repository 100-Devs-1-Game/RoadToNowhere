class_name DrawCardState
extends StateMachineState

signal drawn_card(tile_to_place: CardData)

@export var skip: bool= true



func on_enter():
	if skip:
		drawn_card.emit(Global.level.draw_card())


func on_card_drawn():
	if is_current_state():
		drawn_card.emit(Global.level.draw_card())
		return
