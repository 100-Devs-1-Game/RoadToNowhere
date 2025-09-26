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
		button_buy.disabled= Player.money < data.cost
	
	await get_tree().process_frame
	spin_box.scale*= 2


func _on_button_buy_pressed() -> void:
	card.data.unlocked= true
	Player.buy(card.data.cost)
	buy_card.emit(card.data)
