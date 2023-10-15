extends Panel


const SEASONS = ["spring", "summer", "fall", "winter"]


onready var display_time = $DisplayTime
onready var text_week = $DisplayTime/Texts/Week
onready var text_season = $DisplayTime/Texts/Season
onready var text_year = $DisplayTime/Texts/Year

onready var overlay_turning = $Controls/OverlayTurning
onready var overlay_paused = $Controls/OverlayPaused
onready var overlay_speed = $Controls/OverlaySpeed

onready var speed_1 = $Controls/Speed1
onready var speed_2 = $Controls/Speed2
onready var speed_3 = $Controls/Speed3
onready var speed_4 = $Controls/Speed4
onready var speeds = [speed_1, speed_2, speed_3, speed_4]



func load_data(turn):
	var week = get_season_week(turn) + 1
	var season = SEASONS[get_season(turn)]
	var year = get_year(turn) + 1
	
	format_display_time(week, season, year)

func format_display_time(week, season, year):
	text_week.text = str(week)
	text_season.text = str(season + ",")
	text_year.text = str(year)


func get_week(turn):
	return turn % 52

func get_season(turn):
	return (turn % 52)/13

func get_year(turn):
	return floor(turn/52)

func get_season_week(turn):
	return turn % 13

func set_pause_control_overlay(paused):
	if paused: 
		overlay_turning.hide()
		overlay_paused.show()
	else:
		overlay_turning.show()
		overlay_paused.hide()

func set_speed_overlay(speed):
	overlay_speed.set_position(speeds[speed].rect_position + Vector2(16,16))
