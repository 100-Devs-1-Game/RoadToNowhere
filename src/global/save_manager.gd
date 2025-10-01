extends Node

const SAVE_FILE= "user://save_game.json"

var campaign_data: CampaignData



func save_game():
	var dict:= {}
	dict["player"]= Player.serialize()
	dict["campaign"]= campaign_data.serialize()

	var json:= JSON.stringify(dict)
	var file= FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_string(json)
	file.close()


func load_game():
	if not FileAccess.file_exists(SAVE_FILE):
		return
		
	var str: String= FileAccess.get_file_as_string(SAVE_FILE)
	var dict: Dictionary= JSON.parse_string(str)

	Player.deserialize(dict["player"])
	campaign_data.deserialize(dict["campaign"])


func delete_save_file():
	var dir:= DirAccess.open("user://")
	dir.remove(SAVE_FILE.get_file())


func register_campaign(data: CampaignData):
	campaign_data= data
