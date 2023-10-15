class_name Family


signal birth(family)
signal family_removal(family)

var individuals = []
var parents = []
var children = []

var conception
var period

func _init(parents):
	for parent in parents: 
		add_individual(parent, "parent")
	period = Util.roll(4)
	parents[0].partner = parents[1]
	parents[1].partner = parents[0]

func add_individual(individual, type):
	individuals.append(individual)
	if type == "parent": parents.append(individual)
	if type == "child": children.append(individual)
	individual.family = self

func remove_individual(individual):
	individuals.erase(individual)
	parents.erase(individual)
	children.erase(individual)
	if individuals.size() == 0: emit_signal("family_removal", self)

func get_fertility():
	if parents.size() == 2:
		return parents[0].fertility * parents[1].fertility * 0.05

func conceive(turn):
	conception = turn.tick

func birth():
	conception = null
	emit_signal("birth", self)

