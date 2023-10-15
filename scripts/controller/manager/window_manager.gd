extends Control



signal view_individuals()

var window_scene = load("res://scenes/Window.tscn")

onready var identity_window = $Windows/Identity
onready var society_window = $Windows/Society
onready var economy_window = $Windows/Economy
onready var politics_window = $Windows/Politics
onready var windows = {
	"identity":identity_window,
	"society":society_window,
	"economy":economy_window,
	"politics":politics_window
}
var open_windows = []
var active_window

func _ready():
	hide()
	for window in windows:
		var window_node = windows[window]
		window_node.hide()
		window_node.key = window
		window_node.connect("activate_window", self, "_on_activate_window")
		window_node.connect("deactivate_window", self, "_on_deactivate_window")

func _on_activate_window(window):
	active_window = window

func _on_deactivate_window():
	active_window = null

func _on_selection(selection):
	pass

func open_window(window_key):
	if windows.has(window_key):
		var window = windows[window_key]
		window.show()
		open_windows.append(window)

func close_window(window_key):
	if windows.has(window_key):
		var window = windows[window_key]
		window.hide()
		open_windows.erase(window)

func _on_mouse_moved(amount):
	if active_window == null: return
	active_window.handle_input(amount)

func _toggle_window(window_key):
	if !windows.has(window_key): return
	var window = windows[window_key] 
	if window.visible == true: close_window(window_key)
	else: open_window(window_key)

func clear_windows():
	for window in windows:
		close_window(window)


func load_window(window, keys, data):
	window.load_datatable(keys, data)

func _on_load_data(window_key, keys, data):
	var window = windows[window_key]
	load_window(window, keys, data)


func _on_individuals_pressed():
	emit_signal("view_individuals")
