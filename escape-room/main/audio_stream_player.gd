extends AudioStreamPlayer

@export var start_sequence:AudioStreamWAV = load("res://main/Audio/game3_sequence.wav")
@export var start_loop:AudioStreamWAV = load("res://main/Audio/game3_looped.wav")
@export var end:AudioStreamWAV = load("res://main/Audio/game3_second_half.wav")

var start := true

func _on_music_finished() -> void:
	if start :
		playStream(start_sequence)
	else :
		playStream(end)
	
func playCombatTrack(is_start:bool) -> void:
	if is_start :
		if stream != start_sequence || stream != start_loop:
			playStream(start_sequence)
		start = false
	else :
		playStream(end)

func playStream(audioStream: AudioStream) -> void:
	if stream == audioStream and playing:
		return
	stop()
	stream = audioStream
	play()
