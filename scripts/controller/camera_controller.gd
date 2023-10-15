extends Camera2D

signal camera_movement(amount)
signal camera_zoom(zoom_level)

export var pan_factor := 0.7
export var min_zoom := 0.1
export var max_zoom := 4.0
export var zoom_factor := 0.1
export var zoom_duration := 0.2
export var target_position = Vector2(0,0)

var zoom_level := 1.0 setget set_zoom_level

onready var tween: Tween = $Tween

func _init(): 
	target_position = position

func _process(delta):
	# var movement = lerp(position, target_position, 0.2)
	# print("TP: ", target_position, "  POS: ", position, "  MOVE: ", movement)
	# translate(movement)
	pass


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		set_zoom_level(zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out"): 
		set_zoom_level(zoom_level + zoom_factor)
	if event.is_action("pan_up"): target_position += Vector2(0,1)
	if event.is_action("pan_down"): target_position += Vector2(0,-1)
	if event.is_action("pan_left"): target_position += Vector2(-1,0)
	if event.is_action("pan_right"): target_position += Vector2(1,0)
	


func pan(amount):
	var movement = amount * pan_factor * zoom_level
	translate(movement)
	emit_signal("camera_movement", movement)
	
func set_zoom_level(value: float) -> void:
	zoom_level = clamp(value, min_zoom, max_zoom)
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(zoom_level, zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		tween.EASE_OUT
	)
	tween.start()
	emit_signal("camera_zoom", zoom_level)
