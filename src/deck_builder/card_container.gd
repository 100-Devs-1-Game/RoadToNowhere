class_name CardContainer
extends PanelContainer

signal buy_card(data: CardData)

@onready var card: Card = %Card
@onready var spin_box: SpinBox = %SpinBox
@onready var button_buy: Button = %"Button Buy"



func init(data: CardData):
	card.init(data)
	spin_box.visible= data.unlocked
	button_buy.visible= not data.unlocked
	if button_buy.visible:
		button_buy.text= str("$", data.cost)


func _on_button_buy_pressed() -> void:
	buy_card.emit(card.data)
