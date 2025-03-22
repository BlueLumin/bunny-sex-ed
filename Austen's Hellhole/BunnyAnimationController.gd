extends CharacterBody2D

@export var _bunnyAnimations: AnimatedSprite2D
@export var _fuckingAudio: AudioStreamPlayer2D

func playIdle():
	_bunnyAnimations.play("Idle")
	
func playFucking():
	_bunnyAnimations.play("Fucking")
	_fuckingAudio.play();
