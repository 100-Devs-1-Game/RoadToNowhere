class_name HelpModeState
extends StateMachineState



func on_unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		var desc: String= Global.city.get_description(Global.city.get_mouse_tile())
		Global.level.set_description(desc)
