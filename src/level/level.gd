class_name Level
extends Node2D

@export var empty_card_scene: PackedScene
@export var card_scene: PackedScene

@export var deck_card_offset: float= 2.0

@onready var ui_deck: Control = %Deck
@onready var state_machine: LevelStateMachine = $"State Machine"

var deck: Deck



func _ready() -> void:
	Global.level= self


func build_deck():
	for i in deck.get_size():
		var card: EmptyCard= empty_card_scene.instantiate()
		ui_deck.add_child(card)
		card.position= Vector2.ONE * i * deck_card_offset
		card.activated.connect(state_machine.draw_card.on_card_drawn)


func draw_card()-> CardData:
	var top_card_node: Control= get_top_deck_card()
	var last_pos: Vector2= top_card_node.position
	top_card_node.queue_free()
	var card: Card= card_scene.instantiate()
	ui_deck.add_child(card)
	card.position= last_pos
	card.init(deck.pop())
	return card.data


func pop_deck():
	get_top_deck_card().queue_free()


func get_top_deck_card():
	return ui_deck.get_child(ui_deck.get_child_count() - 1)


func is_deck_empty():
	return deck.is_empty()
