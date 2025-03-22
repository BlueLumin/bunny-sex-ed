class_name Bunny extends CharacterBody2D

enum STATES {IDLE, HEAT, MOVE_TOWARDS_MATE, MATE, PICKED_UP}

@export var cooldown_timer: Timer
@export var min_cooldown_timer: float = 2.0
@export var max_cooldown_timer: float = 4.0
@export var mating_area: Area2D

var current_state: STATES = STATES.IDLE
var current_mate: Bunny = null


func _ready() -> void:
	cooldown_timer.timeout.connect(enter_heat)
	mating_area.area_entered.connect(_on_area_entered)
	
	enter_idle()


func _physics_process(delta: float) -> void:
	if current_state == STATES.MOVE_TOWARDS_MATE:
		move_towards_mate(delta)


# IDLE
func enter_idle() -> void:
	current_state = STATES.IDLE
	
	var cooldown_time: float = randf_range(min_cooldown_timer, max_cooldown_timer)
	
	cooldown_timer.set_wait_time(cooldown_time)
	cooldown_timer.start()


# HEAT
func enter_heat() -> void:
	current_state = STATES.HEAT


func found_mate(mate: Bunny) -> void:
	current_mate = mate
	current_state = STATES.MOVE_TOWARDS_MATE


func move_towards_mate(delta: float) -> void:
	var direction: Vector2 = global_position.direction_to(current_mate.global_position).normalized()
	var speed: float = 100.0
	var target_velocity: Vector2 = direction * speed
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-10 * delta))
	move_and_slide()


# MATE
func start_mating() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, get_physics_process_delta_time())
	current_state = STATES.MATE


func mate_with_mate() -> void:
	pass


# PICKED UP
func picked_up() -> void:
	pass


# Signals
func _on_area_entered(area: Area2D) -> void:
	if area.owner == current_mate:
		start_mating()
