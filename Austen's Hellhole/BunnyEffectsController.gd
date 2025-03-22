extends CharacterBody2D

@export var _bunnyAnimations: AnimatedSprite2D
@export var _spawnAudio: Array[AudioStreamPlayer2D]
@export var _clickedAudio: Array[AudioStreamPlayer2D]
@export var _droppedAudio: Array[AudioStreamPlayer2D]
@export var _interruptAudio: Array[AudioStreamPlayer2D]
@export var _heatColor: Color

func playIdle():
	_bunnyAnimations.play("Idle")
	

func playWalking():
	_bunnyAnimations.play("Walking")

func playFucked():
	_bunnyAnimations.play("Fucked")
	
func playSpawn():
	_bunnyAnimations.play("Spawn")
	playAudioAtRandomPitch(_spawnAudio[randi_range(0, _spawnAudio.size() - 1)], 0.9, 1.1)


func playLearning():
	_bunnyAnimations.play("Learning")

func playClicked():
	_bunnyAnimations.play("Clicked")
	playAudioAtRandomPitch(_clickedAudio[randi_range(0, _clickedAudio.size() - 1)], 0.9, 1.1)

	
func playDropped():
	_bunnyAnimations.play("Idle")
	playAudioAtRandomPitch(_droppedAudio[randi_range(0, _droppedAudio.size() - 1)], 0.9, 1.1)


func playInterrupt():
	_bunnyAnimations.play("Interrupt")
	playAudioAtRandomPitch(_interruptAudio[randi_range(0, _interruptAudio.size() - 1)], 0.9, 1.1)
	

func playAudioAtRandomPitch(audio: AudioStreamPlayer2D, min: float, max : float):
	audio.pitch_scale = randf_range(min, max)
	audio.play()
