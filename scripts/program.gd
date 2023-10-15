extends Node

onready var model = $Model
onready var controller = $Controller
onready var view = $View
onready var camera = $Camera
onready var settings = $Settings




func _ready():
	OS.set_window_fullscreen(!OS.window_fullscreen)
	
func _process(delta):
	if model.world == null:
		return
	var data = model.get_data()
	view.gui.debug.load_data(data)
	model.refresh(camera)

func start_world(world):
	model.load_world(world)
	controller.load_world(world)
	view.gui.menu.hide()
	view.gui._update(world)

func exit():
	get_tree().quit()



