class_name EmptyCard
extends PanelContainer

signal activated


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_MASK_LEFT:
				activated.emit()
