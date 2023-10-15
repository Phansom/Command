extends Node



const GAME_SPEEDS = [1, 3, 9, 27]
const PAUSE_COOLDOWN = 1

onready var clock = get_node("/root/Program/View/GUI/Toolbar/Clock")

const GAME_SPEED_UPDATE_TIME = 0.3

signal tick(tick)
var game_speed = 0
var speed_setting = 0
var game_time = 0
var last_tick = 0
var paused = true
var pause_cooldown = 0
var game_speed_update_timer = 0

func _process(delta):
	update_game_speed_update_timer(delta)
	update_pause_cooldown(delta)
	if paused: return
	game_time += delta * game_speed
	if floor(game_time) > last_tick:
		last_tick = int(floor(game_time))
		emit_signal("tick", last_tick)
		clock.load_data(last_tick)

func _input(event):
	if game_speed_update_timer != 0: return
	if event.is_action("increase_speed"): increase_speed()
	if event.is_action("decrease_speed"): decrease_speed()
	if event.is_action("pause"): if pause_cooldown == 0: toggle_pause()
	if event.is_action("set_speed_1"): set_game_speed_setting(0)
	if event.is_action("set_speed_2"): set_game_speed_setting(1)
	if event.is_action("set_speed_3"): set_game_speed_setting(2)
	if event.is_action("set_speed_4"): set_game_speed_setting(3)

func update_pause_cooldown(delta):
	if pause_cooldown == 0: return
	pause_cooldown -= delta
	if pause_cooldown < 0: pause_cooldown = 0

func update_game_speed_update_timer(delta):
	if game_speed_update_timer != 0:
		game_speed_update_timer -= delta
		if game_speed_update_timer < 0:
			game_speed_update_timer = 0

func on_new_game():
	set_game_speed_setting(0)
	game_time = 0
	last_tick = -1
	paused = true
	clock.set_pause_control_overlay(paused)
	clock.load_data(0)

func increase_speed():
	if speed_setting >= 3: return
	else: set_game_speed_setting(speed_setting + 1)

func decrease_speed():
	if speed_setting <= 0: return
	else: set_game_speed_setting(speed_setting - 1)
	
func toggle_pause():
	if paused: paused = false
	else: paused = true
	pause_cooldown = PAUSE_COOLDOWN
	clock.set_pause_control_overlay(paused)

func set_game_speed_setting(speed_setting):
	self.speed_setting = speed_setting
	game_speed = GAME_SPEEDS[speed_setting]
	clock.set_speed_overlay(speed_setting)
	game_speed_update_timer = GAME_SPEED_UPDATE_TIME
