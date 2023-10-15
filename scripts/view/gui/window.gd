extends Panel


onready var settings = get_node("/root/Program/Settings")
var datatable_scene = load("res://scenes/DataTable.tscn")

signal activate_window(window)
signal deactivate_window()


var key
 

var resize = false
var drag = false
var pinned = false


const MIN_POSITION = Vector2(0,0)
const SCREEN_SIZE = Vector2(1920,1080)

func _ready():
	hide()

func handle_input(mouse_movement):
	if resize:
		resize(mouse_movement)
	if drag:
		drag(mouse_movement)

func start_drag():
	drag = true
	emit_signal("activate_window", self)

func stop_drag():
	drag = false
	emit_signal("deactivate_window")

func start_resize():
	resize = true
	emit_signal("activate_window", self)

func stop_resize():
	resize = false
	emit_signal("deactivate_window")

func drag(amount):
	var new_position = rect_position - amount
	var MAX_POSITION = get_max_position(rect_size)
	if new_position.x < MIN_POSITION.x: new_position.x = MIN_POSITION.x
	if new_position.x > MAX_POSITION.x: new_position.x = MAX_POSITION.x
	if new_position.y < MIN_POSITION.y: new_position.y = MIN_POSITION.y
	if new_position.y > MAX_POSITION.y: new_position.y = MAX_POSITION.y
	set_position(new_position)

func resize(amount):
	set_size(rect_size - amount)

func close():
	print("closed")
	hide()

func toggle():
	if visible == false: show()
	else: hide()

func pin():
	if !pinned: pinned = true
	else: pinned = false

func load_datatable(keys, data):
	var datatable = datatable_scene.instance()
	add_child(datatable)
	datatable.load_data(keys, data)
	

static func get_max_position(size):
	var max_position = SCREEN_SIZE - size
	return max_position
