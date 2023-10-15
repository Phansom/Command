extends Node2D

signal mouse_pressed(position)
signal mouse_released(position)
signal mouse_right_click(position)
signal mouse_right_released(position)
signal mouse_scrolled(direction)
signal mouse_dragged(amount)
signal mouse_moved(amount)

var drag = false
var drag_amount = Vector2(0,0)
var active = true
var mouse_position
var build_mode_active = false



func _unhandled_input(event):
	if !active:
		return
		
	mouse_position = get_viewport().get_mouse_position() - get_viewport_rect().size/2
	
	if (event is InputEventMouseMotion):
		mouse_motion(event)
		
	if not (event is InputEventMouseButton):
		return
		
	if (event.is_pressed()):
		mouse_pressed(event)
	else:
		mouse_released(event)



func mouse_pressed(event):
	if event.button_index == BUTTON_LEFT:
		emit_signal("mouse_pressed", mouse_position)
	
	if event.button_index == BUTTON_RIGHT:
		drag = true
		emit_signal("mouse_right_click", mouse_position)
		
	if event.button_index == BUTTON_WHEEL_UP || BUTTON_WHEEL_DOWN:
		mouse_scroll(event)

func mouse_released(event):
	if event.button_index == BUTTON_LEFT:
		emit_signal("mouse_released", mouse_position)
		
	if event.button_index == BUTTON_RIGHT:
		drag = false
		emit_signal("mouse_right_released", mouse_position)

func mouse_motion(event):
	var move_amount = -event.relative
	emit_signal("mouse_moved", move_amount)
	if (drag == true):
		emit_signal("mouse_dragged", move_amount)

func mouse_scroll(event):
	var direction
	if (event.button_index == BUTTON_WHEEL_UP):
		direction = "up"
	else: 
		direction = "down"
		
	emit_signal("mouse_scrolled", direction)

