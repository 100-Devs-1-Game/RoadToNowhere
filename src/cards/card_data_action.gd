class_name CardDataAction
extends CardData

@export var action: BaseAction



func get_display_name()-> String:
	return action.display_name


func get_icon()-> Texture2D:
	return action.icon
