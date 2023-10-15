class_name Individual

const VIEW_ATTRIBUTES = ["name", "sex", "age_val"]

const NAMES = [
	"Aka", "Ana",
	"Ba", "Bu",
	"Cao",
	"Daka", "Don",
	"Ena", "Eta",
	"Fen", "Fa",
	"Ga", "Gen",
	"Haka", "Het",
	"Ina", "Isk",
	"Jaka", "Jan",
	"Ka", "Kina",
	"Laka", "Lida",
	"Maka", "Mila",
	"Na", "Nia",
	"Ona", "Osa",
	"Paka", "Pell",
	"Quo",
	"Raka", "Rina",
	"Saka", "Sina",
	"Taka", "Tess",
	"Una", "Uln",
	"Vek", "Vik",
	"Waka", "Win",
	"Xa", "Xin",
	"Ya", "Yin",
	"Za", "Zin"
]

const FERTILITIES = {"male": [0, 0, 0, 1, 1, 0.8, 0.6, 0.4, 0.1],
					 "female": [0, 0, 0, 1, 1, 0.5, 0, 0, 0]}
const DEATHRATES = [0.1, 0.04, 0.01, 0.005, 0.005, 0.01, 0.04, 0.1, 0.2]
const PROPERTIES = ["name","sex","age"]
const CONDITIONS = []
const RELATIONSHIPS = ["parent","child","sibling","partner"]
const ASSOCIATIONS = ["family","household","business","tribe","community"]

const SEXES = ["female", "male", "intersex", "nonbinary"]



signal death(ind)


var turn


var name
var sex
var birthturn
var fertility
var deathrate
var deathweek
var age

var age_val

var hunger = 0


var partner
var parents

var settlement
var family


func _init(attributes):
	for key in attributes:
		var val = attributes[key]
		set(key, val)
		
	age_val = age.val
	fertility = get_fertility()
	deathrate = get_deathrate()

func _update(turn):
	self.turn = turn

func die():
	emit_signal("death", self)

func _age():
	age.val += 1
	if age.val >= age.milestone:
		age.id += 1
		age.key = Age.AGE_KEYS[age.id]
		age.milestone = Age.AGE_VALS[age.id + 1]
	
	fertility = get_fertility()
	deathrate = get_deathrate()
	age_val = age.val

func get_fertility():
	return FERTILITIES[sex][age.id]

func get_deathrate():
	return DEATHRATES[age.id]

static func get_age_val(birth, tick):
	var weeks = tick - birth
	var years = weeks/52
	return int(years)
