class_name Canion
extends Node2D


export var proyectil:PackedScene = null
export var cadenciaDisparo:float = 0.8
export var velocidadProyectil:int = 100
export var danioProyectil:float = 1.0

var puntosDisparo:Array = []

onready var timerEnfriamiento:Timer = $TimerEnfriamiento
onready var disparosSFX:AudioStreamPlayer2D = $DisparosSFX
onready var estaEnfriado:bool = true
onready var estaDisparando:bool = false setget setEstaDisparando
onready var puedeDisparar:bool = true setget setPuedeDisparar


#setters/getters
func setEstaDisparando(disparando: bool) -> void:
	estaDisparando = disparando


func setPuedeDisparar(puede: bool) -> void:
	puedeDisparar = puede


func _ready() -> void:
	almacenarPuntosDisparo()
	timerEnfriamiento.wait_time = cadenciaDisparo


func _process(delta: float) -> void:
	if estaDisparando and estaEnfriado and puedeDisparar:
		disparar()


func almacenarPuntosDisparo() -> void:
	for nodo in get_children():
		if nodo is Position2D:
			puntosDisparo.append(nodo)


func disparar() -> void:
	estaEnfriado = false
	timerEnfriamiento.start()
	for puntoDisparo in puntosDisparo:
		var new_proyectil:Proyectil = proyectil.instance()
		new_proyectil.crear(
			puntoDisparo.global_position,
			get_owner().rotation,
			velocidadProyectil,
			danioProyectil
		)
		Eventos.emit_signal("disparo", new_proyectil)
		disparosSFX.play()


func _on_TimerEnfriamiento_timeout() -> void:
	estaEnfriado = true
