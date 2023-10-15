extends Control

onready var item_list = $ItemList

func load_data(keys, vals):
	if item_list == null: item_list = $ItemList
	item_list.clear()
	item_list.max_columns = keys.size()
	for key in keys:
		item_list.add_item(key)
	for val in vals:
		item_list.add_item(str(val))
