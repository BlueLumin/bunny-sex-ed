extends Node2D

var bunnies: Array = []
var bunnies_in_heat: Array[Bunny] = []


func _ready() -> void:
	bunnies = get_tree().get_nodes_in_group("bunny")


func _process(delta: float) -> void:
	calculate_bunnies_in_heat()


func calculate_bunnies_in_heat() -> void: # Bunnies must remove themselves.
	if bunnies.is_empty():
		return
	
	bunnies_in_heat.clear()
	
	for bunny in bunnies:
		if check_if_bunny_viable(bunny) and not bunnies_in_heat.has(bunny):
			bunnies_in_heat.append(bunny)
	
	pair_bunnies()


func check_if_bunny_viable(bunny: Bunny) -> bool:
	if bunny.current_state == bunny.STATES.HEAT and bunny.current_mate == null:
		return true
	return false


func get_mate(looking_bunny: Bunny) -> Bunny:
	if bunnies_in_heat.is_empty():
		return null
	
	var filtered_list: Array[Bunny] = bunnies_in_heat.duplicate()
	
	filtered_list.filter(func(bunny): return bunny != looking_bunny)
	
	if filtered_list.is_empty():
		return null
	
	return filtered_list.pick_random()


func pair_bunnies() -> void:
	if bunnies_in_heat.size() > 1:
		var bunny_1: Bunny
		var bunny_2: Bunny
		
		var filtered_list: Array[Bunny] = bunnies_in_heat.duplicate()
		
		bunny_1 = filtered_list.pick_random()
		filtered_list.erase(bunny_1)
		bunny_2 = filtered_list.pick_random()
		
		bunny_1.found_mate(bunny_2)
		bunny_2.found_mate(bunny_1)
		
		print("Paired ", bunny_1.name, " & ", bunny_2.name)
