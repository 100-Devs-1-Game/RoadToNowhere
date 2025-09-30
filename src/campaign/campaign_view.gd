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
	
	if not SaveManager.campaign_data:
		SaveManager.register_campaign(data)
		SaveManager.load_game()
	else :
		SaveManager.save_game()
	
	if data.level_scores.is_empty():
		data.level_scores.resize(data.level_data.size())
	
	update()


func update():
	label_money.text= Player.get_money_str()
	
	UIUtils.free_children(grid_container)
	
	#var cant_unlock:= false
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
		play_button.pressed.connect(on_play_level.bind(level_data))
		
		if level_data.unlocked:
			UIUtils.add_empty(grid_container)
		elif data.level_scores[i - 1] >= get_unlock_score(i):
			UIUtils.add_empty(grid_container)
			level_data.unlocked= true
		else:
			label= UIUtils.add_label(grid_container, "Unlock with %d score" % get_unlock_score(i))
			label.label_settings= highscore_label_settings
	
		play_button.disabled= not level_data.unlocked or not Player.is_deck_perfect_size()


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


func get_unlock_score(level: int)-> int:
	return level * 5
