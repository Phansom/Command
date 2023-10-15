extends Node2D


onready var data_view = $DataView
onready var toolbar = $Toolbar
onready var event_log = $EventLog
onready var debug = $Debug
onready var clock = $Clock
onready var menu = $Menu
onready var window_manager = $WindowManager
onready var databar = $Toolbar/Databar


var world
var data_tables = []


func _ready():
	menu.show()
	


func _update(world):
	self.world = world
	databar._update(world)
	
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if menu.visible && world != null: menu.hide()
		else: menu.show()



func _on_clear_ui():
	window_manager.clear_windows()


func _on_select_tab_individuals(key):
	var keys = Individual.VIEW_ATTRIBUTES
	var vals = world.civilization.identity.get_individual_data(keys)
	data_view.view_data("individuals", keys, vals)
