extends PanelContainer

@export var data: CampaignData

@export var play_button_scene: PackedScene
@export var unlock_button_scene: PackedScene
@export var level_label_settings: LabelSettings
@export var highscore_label_settings: LabelSettings

@onready var grid_container: GridContainer = %GridContainer
@onready var label_money: Label = %"Label Money"



func _ready() -> void:
	if not Player.campaign_data:
		Player.campaign_data= data
		
	update()


func update():
	label_money.text= Player.get_money_str()
	
	UIUtils.free_children(grid_container)
	
	var cant_unlock:= false
	var label: Label
	for i in data.level_data.size():
		var level_data: LevelData= data.level_data[i]
		var highscore: int= 0
		if data.level_scores.size() > i:
			highscore= data.level_scores[i]
		
		label= UIUtils.add_label(grid_container, str("Level ", i + 1))
		label.label_settings= level_label_settings

		var highscore_text:= "No Highscore"
		if highscore > 0:
			highscore_text= str("Highscore: ", highscore)

		label= UIUtils.add_label(grid_container, highscore_text)
		label.label_settings= highscore_label_settings

		var play_button: Button= play_button_scene.instantiate()
		grid_container.add_child(play_button)
		play_button.disabled= not level_data.unlocked
		play_button.pressed.connect(on_play_level.bind(level_data))
		
		if level_data.unlocked:
			UIUtils.add_empty(grid_container)
		else:
			var unlock_button: Button= unlock_button_scene.instantiate()
			var cost: int= i * 10
			unlock_button.text= "Unlock [ $%d ]" % [ cost ]
			if cant_unlock or Player.money < cost:
				unlock_button.disabled= true
			grid_container.add_child(unlock_button)
			unlock_button.pressed.connect(on_unlock.bind(level_data, cost))
			cant_unlock= true


func on_unlock(level_data: LevelData, cost: int):
	level_data.unlocked= true
	Player.buy(cost)
	update()


func on_play_level(level_data: LevelData):
	SceneLoader.play_level(level_data)


func _on_button_deck_pressed() -> void:
	SceneLoader.build_deck()


func _on_button_exit_pressed() -> void:
	SceneLoader.enter_main_menu()
