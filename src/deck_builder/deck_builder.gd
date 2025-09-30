class_name DeckBuilder
extends PanelContainer

@export var increase_deck_size_cost: int= 5
@export var swap_cost: int= 25
@export var skip_cost: int= 25
@export var card_container_scene: PackedScene
@export var transparent_label_frame: StyleBoxFlat
@export var red_label_frame: StyleBoxFlat


@onready var display_container: GridContainer = %GridContainer
@onready var label_money: Label = %"Label Money"
@onready var button_increase_deck_size: Button = %"Button Increase Deck Size"
@onready var label_deck_size: Label = %"Label Deck Size"
@onready var button_play: Button = %"Button Play"
@onready var button_swap: Button = %"Button Swap"
@onready var button_skip: Button = %"Button Skip"



func _ready() -> void:
	button_increase_deck_size.text= str("Increase $", increase_deck_size_cost)
	
	if Player.deck.is_empty():
		initialize_deck()
	update()


func initialize_deck():
	while true:
		for card in GameData.card_pool:
			if not card.unlocked:
				continue
			Player.deck.add_card(card)
			if Player.is_deck_perfect_size():
				break
		if Player.is_deck_perfect_size():
			break


func update():
	var deck_size: int= Player.deck.get_size()
	label_deck_size.text= "Deck Size %d/%d" % [ deck_size, Player.max_deck_size ]
	if not Player.is_deck_perfect_size(): 
		label_deck_size.add_theme_stylebox_override("normal", red_label_frame)
		button_play.disabled= true
	else:
		label_deck_size.add_theme_stylebox_override("normal", transparent_label_frame)
		button_play.disabled= false
	
	label_money.text= Player.get_money_str()
	button_increase_deck_size.disabled= Player.money < increase_deck_size_cost

	UIUtils.free_children(display_container)
	
	for i in 10:
		var card: CardData
		if i < GameData.card_pool.size():
			card= GameData.card_pool[i]
			var card_container: CardContainer= card_container_scene.instantiate()
			display_container.add_child(card_container)
			card_container.init(card)
			card_container.bought_card.connect(on_card_bought)
			card_container.deck_updated.connect(on_deck_updated)

	if Player.has_skip_joker:
		button_skip.text= "Bought"
		button_skip.disabled= true
	else:
		button_skip.text= str("$", skip_cost)
		button_skip.disabled= Player.money < skip_cost

	if Player.has_swap_joker:
		button_swap.text= "Bought"
		button_swap.disabled= true
	else:
		button_swap.text= str("$", swap_cost)
		button_swap.disabled= Player.money < swap_cost


func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if not event.is_pressed():
		return
	
	if event is InputEventKey:
		if event.keycode == KEY_F1:
			Player.earn(100)
			update()


func on_card_bought(card_data: CardData):
	update()


func on_deck_updated():
	update()


func _on_button_play_pressed() -> void:
	SceneLoader.enter_campaign()


func _on_button_increase_deck_size_pressed() -> void:
	Player.max_deck_size+= 2
	Player.buy(increase_deck_size_cost)
	update()


func _on_button_swap_pressed() -> void:
	Player.has_swap_joker= true
	update()


func _on_button_skip_pressed() -> void:
	Player.has_skip_joker= true
	update()
