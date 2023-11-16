class_name NaveBase
extends RigidBody2D


enum Estado {VIVO, MUERTO, SPAWN, INVENCIBLE}

export var hitPoints:float = 20.0

var estadoActual:int = Estado.SPAWN


onready var canion:Canion = $Canion

onready var inpactoSFX: AudioStreamPlayer = $InpactoSFX
onready var colisionador:CollisionShape2D = $CollisionShape2D


func controladorEstados(nuevoEstado: int) ->void:
	match nuevoEstado:
		Estado.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.setPuedeDisparar(false)
			print("spawn")
		Estado.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.setPuedeDisparar(true)
			print("vivo")
		Estado.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		Estado.MUERTO:
			print("muerto")
			colisionador.set_deferred("disabled", true)
			canion.setPuedeDisparar(false)
			Eventos.emit_signal("naveDestruida", global_position, 3)
			queue_free()
		_:
			print("Error")
	estadoActual = nuevoEstado


func _ready() -> void:
	controladorEstados(estadoActual)


func recibirDanio(danio: int) -> void:
	hitPoints -= danio
	inpactoSFX.play()
	if hitPoints <= 0.0:
		destruir()


func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	controladorEstados(Estado.MUERTO)


func _on_Player_body_entered(body: Node) -> void:
	if body is Meteorito:
		print("Nave impacta Meteorito")
		body.destruir()
		destruir()
