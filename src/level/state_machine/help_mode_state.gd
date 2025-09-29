class_name HelpModeState
extends StateMachineState

@export_multiline var default_description: String



func on_enter():
	Global.level.set_description(default_description)


func on_unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		var desc: String= Global.city.get_description(Global.city.get_mouse_tile())
		if desc.is_empty():
			desc= default_description
		Global.level.set_description(desc)
