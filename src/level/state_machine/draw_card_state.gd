class_name DrawCardState
extends StateMachineState

signal drawn_card(tile_to_place: CardData)

@export var skip: bool= true
@export var skip_delay: float= 0.3



func on_enter():
	if skip:
		await get_tree().process_frame
		await get_tree().create_timer(skip_delay).timeout
		drawn_card.emit(Global.level.draw_card())


func on_card_drawn():
	if not skip and is_current_state():
		drawn_card.emit(Global.level.draw_card())
		return
