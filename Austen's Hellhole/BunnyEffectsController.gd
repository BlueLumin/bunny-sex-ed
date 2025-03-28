class_name BunnyAnimation extends Node2D

@export var _bunnyAnimations: AnimatedSprite2D
@export var bunny_click_audio_player: AudioStreamPlayer
@export var bunny_drop_audio_player: AudioStreamPlayer
@export var bunny_climax_audio_player: AudioStreamPlayer
@export var bunny_inturrupt_audio_player: AudioStreamPlayer
@export var bunny_spawn_audio_player: AudioStreamPlayer
@export var _heatColor: Color


func playIdle():
	_bunnyAnimations.play("Idle")
	

func playWalking():
	_bunnyAnimations.play("Walking")


func playFucked():
	_bunnyAnimations.play("Fucked")
	bunny_climax_audio_player.play()
	
	
func playSpawn():
	_bunnyAnimations.play("Spawn")
	bunny_spawn_audio_player.play()


func playLearning():
	_bunnyAnimations.play("Learning")


func playClicked():
	_bunnyAnimations.play("Clicked")
	bunny_click_audio_player.play()

	
func playDropped():
	_bunnyAnimations.play("Idle")
	bunny_drop_audio_player.play()


func playInterrupt():
	bunny_inturrupt_audio_player.play()
	


func animation_finished() -> void:
	if _bunnyAnimations.animation == "Spawn":
		_bunnyAnimations.play("Idle")
