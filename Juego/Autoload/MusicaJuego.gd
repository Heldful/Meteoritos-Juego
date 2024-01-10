extends Node


onready var musicaNivel:AudioStreamPlayer = $MusicaNivel
onready var musicaCombate:AudioStreamPlayer = $MusicaCombate
onready var tweenOn:Tween = $TweenMusicaOn
onready var tweenOff:Tween = $TweenMusicaOff


#func set_streams(streamMusica: AudioStream, streamCombate: AudioStream) -> void:
#		musicaNivel.stream = streamMusica
#		musicaCombate.stream = streamCombate
	
	
func play_musicaNivel() -> void:
	stop_todo()
	musicaNivel.play()


func stop_todo() -> void:
	for nodo in get_children():
		if nodo is AudioStreamPlayer:
			nodo.stop()


