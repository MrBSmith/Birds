extends Node
class_name SingComponent

@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func sing() -> void:
	audio_stream_player.play()
