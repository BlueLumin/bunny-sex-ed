extends Node2D

const BUNNY = preload("res://Bunny/bunny.tscn")
const MATING_BUNNIES = preload("res://MatingBunnies/mating_bunnies.tscn")

@export var idle_time_range: Vector2 = Vector2(2.0, 10.0)
@export var mating_time: float = 5.0
@export var spawn_value_range: Vector2 = Vector2(2, 5)

var bunnies: Array = []
var bunnies_in_heat: Array[Bunny] = []
var mating_bunnies: Array[MatingBunnies] = []


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


func start_mating(location: Vector2, bunny: Bunny) -> void:
	if !mating_bunnies.is_empty():
		for mating_bunny in mating_bunnies:
			for mate in mating_bunny.original_bunnies:
				if mate == bunny.current_mate:
					mating_bunny.original_bunnies.append(bunny)
					return
	
	var mating_instance: MatingBunnies = MATING_BUNNIES.instantiate()
	var layer: Node2D = get_tree().get_first_node_in_group("actors")
	layer.call_deferred("add_child", mating_instance)
	mating_instance.global_position = location
	mating_instance.original_bunnies.append(bunny)
	mating_bunnies.append(mating_instance)


func spawn_bunnies(location: Vector2) -> void:
	var number_of_spawns: int = randi_range(spawn_value_range.x, spawn_value_range.y)
	var spawn_radius: float = 100.0
	
	for n in number_of_spawns:
		var bunny_instance: Bunny = BUNNY.instantiate()
		var layer: Node2D = get_tree().get_first_node_in_group("actors")
		
		layer.call_deferred("add_child", bunny_instance)
		bunny_instance.global_position = location + Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
		bunnies.append(bunny_instance)
