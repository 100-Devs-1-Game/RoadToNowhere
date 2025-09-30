class_name Level
extends Node2D

@export var empty_card_scene: PackedScene
@export var card_scene: PackedScene

@export var deck_card_offset: float= 2.0
@export var buttons: Array[Button]

@onready var city: City = $City
@onready var ui_deck: Control = %Deck
@onready var state_machine: LevelStateMachine = $"State Machine"
@onready var label_description: Label = %"Label Description"
@onready var button_skip: Button = %"Button Skip"
@onready var button_swap: Button = %"Button Swap"
@onready var button_exit: Button = %"Button Exit"

var deck: Deck
var can_skip: bool
var can_swap: bool
var current_card: CardData



func _ready() -> void:
	Global.level= self
	deck= Player.deck.copy()
	deck.shuffle()
	deck.half()
	build_deck()
	
	can_skip= Player.has_skip_joker
	can_swap= Player.has_swap_joker
	update_buttons()


func build_deck():
	for i in deck.get_size():
		var card: EmptyCard= empty_card_scene.instantiate()
		ui_deck.add_child(card)
		card.position= Vector2.ONE * i * deck_card_offset
		card.activated.connect(state_machine.draw_card.on_card_drawn)


func draw_card(replace: bool= false)-> CardData:
	var card: Card
	if not replace:
		var top_card_node: Control= get_top_deck_card()
		var last_pos: Vector2= top_card_node.position
		top_card_node.queue_free()
		card= card_scene.instantiate()
		ui_deck.add_child(card)
		card.position= last_pos
		current_card= deck.pop()
	else:
		card= ui_deck.get_child(ui_deck.get_child_count() - 1)
	
	card.init(current_card)
	return card.data


func pop_deck():
	get_top_deck_card().queue_free()


func tick():
	for tile in city.get_dynamic_object_tiles():
		var obj: DynamicObjectTile= city.get_dynamic_object(tile)
		obj.tick(tile)


func set_description(text: String):
	label_description.text= text


func update_buttons():
	button_skip.disabled= not can_skip
	button_swap.disabled= not can_swap


func get_top_deck_card():
	return ui_deck.get_child(ui_deck.get_child_count() - 1)


func is_deck_empty():
	return deck.is_empty()


func _on_button_help_toggled(toggled_on: bool) -> void:
	state_machine.toggle_help_mode(toggled_on)


func _on_button_exit_pressed() -> void:
	SceneLoader.enter_campaign()


func _on_button_skip_pressed() -> void:
	if deck.get_size() < 2:
		return
	pop_deck()
	can_skip= false
	update_buttons()
	state_machine.change_state(state_machine.draw_card)


func _on_button_swap_pressed() -> void:
	if deck.get_size() < 2:
		return
	deck.add_card(current_card)
	deck.swap()
	can_swap= false
	update_buttons()
	
	current_card= deck.pop()
	draw_card(true)
	state_machine.set_current_state(null)
	state_machine.on_card_drawn(current_card)
