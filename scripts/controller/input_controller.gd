extends Control

signal clear_ui()


var input_keys = [

]



func _input(event):
	if event.is_action("ui_clear"): emit_signal("clear_ui")
