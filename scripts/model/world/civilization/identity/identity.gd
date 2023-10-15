class_name Identity

extends Node


const BASE_HUNGER_RATE = 0.2
const NEED_KEYS = ["hunger","shelter","safety"]
####################################################################################################
const PROPERTY_KEYS = ["sex","age"]
####################################################################################################
const SEX_KEYS = ["female","male"]
const AGE_KEYS = ["infant","child","juvenile","young_adult","adult","old_adult","elder","ancient"]
####################################################################################################
const MATURATION_THRESHOLDS = [0,4,10,17,30,45,60,75]
####################################################################################################

signal death(individual)



var birthweeks
var deathweeks

var turn
var settlements
var individuals
var structures
var dead


func _ready():
	turn = Turn.new(0)
	dead = []
	birthweeks = []
	deathweeks = []
	for i in 52:
		birthweeks.append([])
		deathweeks.append([])

func _load(settlements):
	self.settlements = settlements
	individuals = []
	structures = []
	for settlement in settlements:
		for individual in settlement.individuals:
			add_individual(individual)
		for structure in settlement.structures:
			structures.append(structure)

func _update(turn):
	self.turn = turn
	for individual in individuals:individual._update(turn)
	_aging()
	_metabolism()
	_death()

func add_individual(individual):
	individuals.append(individual)
	birthweeks[individual.birthturn.week].append(individual)
	individual.connect("death", self, "remove_individual")

func remove_individual(individual):
	birthweeks[individual.birthturn.week].erase(individual)
	if individual.deathweek != null: deathweeks[individual.deathweek].erase(individual)
	individual.settlement.individuals.erase(individual)
	individual.family.remove_individual(individual)
	dead.append(individual)
	individuals.erase(individual)	
	emit_signal("death", individual)

func _metabolism():
	for ind in individuals:
		ind.hunger += BASE_HUNGER_RATE

func _aging():
	for ind in birthweeks[turn.week]:
		ind._age()
		if randf() <= ind.deathrate:
			var deathweek = Util.roll(52)
			deathweeks[deathweek].append(ind)
			ind.deathweek = deathweek

func _death():
	for ind in deathweeks[turn.week]:
		ind.die()

func get_individual_data(keys):
	var vals = []
	for ind in individuals:
		for key in keys:
			if key in ind:
				vals.append(ind.get(key))
	return vals

func _on_birth(family):
	var name = Individual.NAMES[Util.roll(Individual.NAMES.size())]
	var parents = family.parents
	var attributes = {"name":name, "sex":SEX_KEYS[Util.roll(2)], "age":Age.new(0), "birthturn":turn, "parents":parents, "family": parents[0].family, "settlement":parents[0].settlement}
	var ind = Individual.new(attributes)
	add_individual(ind)
	parents[0].settlement.individuals.append(ind)
	family.add_individual(ind, "child")
	print("NEW BIRTH")
