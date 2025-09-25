class_name CardData
extends Resource

@export var cost: int
@export var unlocked: bool= false



func get_display_name()-> String:
	assert(false, "Abstract function")
	return ""


func get_icon()-> Texture2D:
	assert(false, "Abstract function")
	return null
