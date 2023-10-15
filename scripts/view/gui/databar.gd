extends Panel


const BASE_TAB_POSITION = Vector2(4,4)
const DATA_TAB_SIZE = Vector2(67,34)
const DATA_KEYS = ["population", "structures", "families", "housing", "buildsites", "food"]

signal tab_selected(key)

onready var data_icons = {
	DATA_KEYS[0]:preload("res://assets/textures/icons/data_tab/icon_population.png"),
	DATA_KEYS[1]:preload("res://assets/textures/icons/data_tab/icon_structures.png"),
	DATA_KEYS[2]:preload("res://assets/textures/icons/data_tab/icon_housing.png"),
	DATA_KEYS[3]:preload("res://assets/textures/icons/data_tab/icon_buildsites.png"),
	DATA_KEYS[4]:preload("res://assets/textures/icons/data_tab/icon_food.png"),
	DATA_KEYS[5]:preload("res://assets/textures/icons/data_tab/icon_families.png")
}



onready var tabs_node = $Tabs



var data_tab_scene = preload("res://scenes/DataTab.tscn")



var tabs = []

func _update(world):
	load_settlement(world.civilization.identity.settlements[0])

func load_settlement(settlement):
	clear_tabs()
	var data = [settlement.individuals.size(), settlement.structures.size(), settlement.get_housing(), 0, 0, settlement.community.families.size()]
	for i in DATA_KEYS.size():
		add_tab(DATA_KEYS[i], data[i])

func clear_tabs():
	for tab in tabs:
		tab.queue_free()
	tabs = []

func add_tab(key, data):
	var tab = _init_tab(data_icons[key], str(data), key)
	tabs.append(tab)
	_position_tab(tab)

func _init_tab(icon, value, key):
	var data_tab = data_tab_scene.instance()
	data_tab.get_child(0).texture = icon
	data_tab.get_child(1).text = value
	data_tab.get_child(2).connect("button_up", self, "_tab_selected", [key])
	tabs_node.add_child(data_tab)
	return data_tab

func _tab_selected(key):
	print("Datatab ", key, " has been selected!")
	emit_signal("tab_selected", key)


func _position_tab(data_tab):
	var tab_count = tabs.size() - 1
	var relative_position = Vector2((DATA_TAB_SIZE.x + 2) * tab_count, 0)
	data_tab.set_position(BASE_TAB_POSITION + relative_position)
	
