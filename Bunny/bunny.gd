class_name Bunny extends CharacterBody2D

enum STATES {IDLE, HEAT, MOVE_TOWARDS_MATE, MATE, PICKED_UP, FUCKED, SCHOOL}

@export var idle_timer: Timer
@export var fucked_cooldown_timer: Timer
@export var animation: BunnyAnimation
@export var mating_area: Area2D
@export var speed: float = 100.0

var current_state: STATES = STATES.IDLE
var current_mate: Bunny = null

var direction: Vector2 = Vector2.ZERO
var over_school: bool = false


func _ready() -> void:
	idle_timer.timeout.connect(enter_heat)
	fucked_cooldown_timer.timeout.connect(_on_fucked_cooldown_timeout)
	mating_area.area_entered.connect(_on_area_entered)
	
	mating_area.area_exited.connect(on_area_exited)
	
	enter_idle()


func _physics_process(delta: float) -> void:
	if current_state == STATES.MOVE_TOWARDS_MATE:
		move_towards_mate()
		
	var target_velocity: Vector2 = direction * speed
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-10 * delta))
	
	move_and_slide()


# IDLE
func enter_idle() -> void:
	current_state = STATES.IDLE
	animation.playIdle()
	current_mate = null
	
	var cooldown_time: float = randf_range(BunnyManager.idle_time_range.x, BunnyManager.idle_time_range.y)
	
	idle_timer.set_wait_time(cooldown_time)
	idle_timer.start()


# HEAT
func enter_heat() -> void:
	current_state = STATES.HEAT
	animation.playWalking()


func found_mate(mate: Bunny) -> void:
	current_mate = mate
	current_state = STATES.MOVE_TOWARDS_MATE
	animation.playWalking()


func move_towards_mate() -> void:
	direction = global_position.direction_to(current_mate.global_position).normalized()


# MATE
func start_mating() -> void:
	direction = Vector2.ZERO
	current_state = STATES.MATE
	set_visible(false)
	BunnyManager.start_mating(global_position, self)


func stop_mating() -> void:
	set_visible(true)
	animation.playFucked()
	current_state = STATES.FUCKED
	fucked_cooldown_timer.set_wait_time(randf_range(BunnyManager.fucked_cooldown_range.x, BunnyManager.fucked_cooldown_range.y))
	fucked_cooldown_timer.start()


func _on_fucked_cooldown_timeout() -> void:
	enter_idle()


# PICKED UP
func picked_up() -> void:
	current_state = STATES.PICKED_UP


# Signals
func _on_area_entered(area: Area2D) -> void:
	if area.owner == current_mate:
		start_mating()
	
	if area is School:
		print("over area")
		over_school = true


var dragging = false

var offset = Vector2(0,0)

func _process(delta):
	if dragging:
		position = get_global_mouse_position() - offset
	

func _on_button_button_down() -> void:
	if current_state == STATES.FUCKED:
		dragging = true # Replace with function body.
		offset = get_global_mouse_position() - global_position
		print("button down******")
	
func _on_button_button_up() -> void:
	dragging = false # Replace with function body.
	if over_school:
		current_state = STATES.SCHOOL
		animation.playLearning()
		idle_timer.stop()
		fucked_cooldown_timer.stop()
		print("area")
	print("button up******")


func on_area_exited(area: Area2D) -> void:
	if area is School:
		print("exited area")
		over_school = false


func leave_school() -> void:
	pass
