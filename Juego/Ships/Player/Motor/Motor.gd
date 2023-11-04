class_name Motor
extends AudioStreamPlayer2D


export var tiempoTransicion:float = 0.6
export var volumenApagado:float = -30

var volumenOriginal:float

onready var tweenSonido:Tween = $Tween


func _ready() -> void:
	volumenOriginal = volume_db
	volume_db = volumenApagado


func sonidoOn():
	if not playing:
		play()
	efectoTransicion(volume_db, volumenOriginal)


func sonidoOff():
	efectoTransicion(volume_db, volumenApagado)


func efectoTransicion(desdeVol: float, hastaVol: float) -> void:
	tweenSonido.interpolate_property(
		self, 
		"volume_db", 
		desdeVol, 
		hastaVol, 
		tiempoTransicion, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT_IN
	)
	tweenSonido.start()
