extends Node


signal birth(family)

var turn

var families = []
var clans = []
var communities = []



func load_communities(communities):
	for community in communities:
		for family in community.families:
			add_family(family)
	self.communities = communities


func add_family(family):
	family.connect("birth", self, "_on_birth")
	family.connect("family_removal", self, "_on_family_removal")
	families.append(family)

func remove_family(family):
	families.erase(family)



func _update(turn):
	self.turn = turn
	_socialization()
	_reproduction()


func _socialization():
	for community in communities:
		var bachelors = community.get_bachelors()
		for bachelor in bachelors:
			if randf() <= 0.02:
				var partner = Community.get_eligible_partner(bachelors, bachelor)
				if partner != null:
					var partners = [bachelor, partner]
					var family = Family.new(partners)
					add_family(family)
					community.families.append(family)

func _reproduction():
	for family in families:
		if family.parents.size() == 2:
			if family.conception == null:
				if family.period == turn.month_week:
					var fertility = family.get_fertility()
					if fertility >= randf():
						family.conceive(turn)
			else:
				if turn.tick - family.conception >= 39:
					family.birth()

func _on_family_removal(family):
	families.erase(family)
	

func _on_birth(family):
	emit_signal("birth", family)
