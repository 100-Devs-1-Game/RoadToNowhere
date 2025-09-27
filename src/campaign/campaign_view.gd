extends PanelContainer

@export var data: CampaignData

@export var play_button_scene: PackedScene
@export var unlock_button_scene: PackedScene
@export var level_label_settings: LabelSettings
@export var highscore_label_settings: LabelSettings

@onready var grid_container: GridContainer = %GridContainer



func _ready() -> void:
	if not Player.campaign_data:
		Player.campaign_data= data
		
	update()


func update():
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
			unlock_button.text= "Unlock [ $%d ]" % [ i*10 ]
			if cant_unlock:
				unlock_button.disabled= true
			grid_container.add_child(unlock_button)
			cant_unlock= true

func on_play_level(level_data: LevelData):
	SceneLoader.play_level(level_data)
