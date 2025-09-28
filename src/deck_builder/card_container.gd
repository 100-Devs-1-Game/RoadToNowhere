class_name CardContainer
extends PanelContainer

signal bought_card(data: CardData)
signal deck_updated

@onready var card: Card = %Card
@onready var button_buy: Button = %"Button Buy"
@onready var label: Label = %"Label Count"
@onready var button_plus: Button = %"Button Plus"
@onready var button_minus: Button = %"Button Minus"
@onready var spin_box: HBoxContainer = %"HBoxContainer Spin Box"



func init(data: CardData):
	card.init(data)
	spin_box.visible= data.unlocked
	button_buy.visible= not data.unlocked
	if button_buy.visible:
		button_buy.text= str("$", data.cost)
		button_buy.disabled= Player.money < data.cost
	else:
		var count: int= Player.deck.get_card_count(data)
		label.text= str(count)
		button_minus.disabled= count == 0
	

func change_label(delta: int):
	var value: int= int(label.text)
	value+= delta
	label.text= str(value)
	button_minus.disabled= value == 0

	if delta > 0:
		Player.deck.add_card(card.data)
	else:
		Player.deck.remove_card(card.data)
	deck_updated.emit()


func _on_button_buy_pressed() -> void:
	card.data.unlocked= true
	Player.buy(card.data.cost)
	bought_card.emit(card.data)


func _on_button_minus_pressed() -> void:
	change_label(-1)


func _on_button_plus_pressed() -> void:
	change_label(1)
