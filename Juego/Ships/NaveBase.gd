class_name NaveBase
extends RigidBody2D


enum Estado {VIVO, MUERTO, SPAWN, INVENCIBLE}


export var hitPoints:float = 20.0
var estadoActual:int = Estado.SPAWN

onready var canion:Canion = $Canion
onready var inpactoSFX: AudioStreamPlayer = $InpactoSFX
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var barraSalud:BarraSalud = $BarraSalud


func controladorEstados(nuevoEstado: int) ->void:
	match nuevoEstado:
		Estado.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.setPuedeDisparar(false)
		Estado.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.setPuedeDisparar(true)
		Estado.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		Estado.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.setPuedeDisparar(false)
			Eventos.emit_signal("naveDestruida", self, global_position, 1)
			queue_free()
		_:
			printerr("Error")
	
	estadoActual = nuevoEstado


func _ready() -> void:
	barraSalud.max_value = hitPoints
	barraSalud.value = hitPoints
	controladorEstados(estadoActual)


func recibirDanio(danio: float) -> void:
	hitPoints -= danio
	barraSalud.controlarBarra(hitPoints, true)
	$InpactoSFX.play()
	if hitPoints <= 0.0:
		destruir()


func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	controladorEstados(Estado.MUERTO)


func _on_Player_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()
