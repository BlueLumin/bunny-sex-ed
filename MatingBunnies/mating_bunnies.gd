class_name MatingBunnies extends Node2D

@export var interupt_area: Area2D
@export var mating_timer: Timer

var original_bunnies: Array[Bunny] = []
var mouse_hovered: bool = false
var mating_progress: int = 0

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var bunny_hump_audio_player: AudioStreamPlayer = $BunnyHumpAudioPlayer
@onready var interupt_audio: AudioStreamPlayer = $Interupt


func _ready() -> void:
	mating_timer.timeout.connect(_on_mating_timer_timeout)
	interupt_area.mouse_entered.connect(_mouse_entered)
	interupt_area.mouse_exited.connect(_mouse_exited)
	
	progress_bar.value = 0
	mating_timer.set_wait_time(BunnyManager.mating_time / 2)
	mating_timer.start()


func _process(delta: float) -> void:
	if mouse_hovered and Input.is_action_just_pressed("interupt"):
		interupt()
	
	mating_progress = floori(BunnyManager.mating_time - mating_timer.time_left)
	
	progress_bar.value = (100 / BunnyManager.mating_time) * mating_progress


func _on_mating_timer_timeout() -> void:
	finish_mating()
	deactivate()


func interupt() -> void:
	mating_timer.stop()
	if mating_progress == 0:
		deactivate()
	else:
		mating_progress -= 1
		mating_timer.set_wait_time(BunnyManager.mating_time - mating_progress)
		mating_timer.start()
	
	interupt_audio.play()


func finish_mating() -> void:
	BunnyManager.spawn_bunnies(global_position)


func deactivate() -> void:
	set_visible(false)
	bunny_hump_audio_player.stop()
	
	for bunny in original_bunnies:
		bunny.stop_mating()
	
	BunnyManager.mating_bunnies.erase(self)
	self.queue_free()


func _mouse_entered() -> void:
	mouse_hovered = true


func _mouse_exited() -> void:
	mouse_hovered = false
