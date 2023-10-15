extends Panel


signal generate_world(map_scale, num_tribes, tribe_size)
onready var txt_map_scale = $MapScale/Text
onready var txt_tribe_size = $TribeSize/Text

func _on_generate_pressed():
	var num_tribes = 1
	var map_scale = int(txt_map_scale.text)
	var tribe_size = int(txt_tribe_size.text)
	emit_signal("generate_world", map_scale, num_tribes, tribe_size)
	hide()


func _on_new_world_pressed():
	show()
