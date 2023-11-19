class_name EnemigoOrbital
extends EnemigoBase

export var rangoMaximoAtaque:float = 1400.0
var estacionOwner:Node2D

func _ready() -> void:
	canion.setEstaDisparando(true)


func crear(posicion: Vector2, owner: Node2D) -> void:
	global_position = posicion
	estacionOwner = owner


func rotarHaciaPlayer() -> void:
	.rotarHaciaPlayer()
	if playerDireccion.length() > rangoMaximoAtaque:

		canion.setEstaDisparando(false)
		
	else:
		canion.setEstaDisparando(true)
