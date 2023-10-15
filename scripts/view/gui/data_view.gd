extends Control


const DATA_KEYS = ["individuals", "structures"]


onready var data_table_scene = preload("res://scenes/DataTable.tscn")


var data_tables = {}


func view_data(data_key, keys, vals):
	if data_tables.has(data_key):
		data_tables[data_key].load_data(keys, vals)
	else:
		_add_data_table(data_key, keys, vals)

func _add_data_table(data_key, keys, vals):
	var data_table = data_table_scene.instance()
	data_table.load_data(keys, vals)
	data_table.set_position(Vector2(5,47))
	add_child(data_table)
	data_tables[data_key] = data_table
