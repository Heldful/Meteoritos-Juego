class_name EstacionRecarga
extends Node2D

export var energiaEstacion:float = 8
export var radioEntregaEnergia:float = 0.1
var navePlayer:Player = null
var playerEnArea:bool = false

onready var vacioSFX: AudioStreamPlayer2D = $VacioSFX
onready var recargaSFX: AudioStreamPlayer2D = $RecargaSFX

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("recargarBeam") or event.is_action("recargarEscudo"):
		alertaVacio()
	if not puedeRecargar(event) or navePlayer == null:
		return 
	
	controlarEnergia()

	if event.is_action("recargarBeam"):
		navePlayer.getBeam().controlarEnergiaBeam(radioEntregaEnergia * 5)
	elif event.is_action("recargarEscudo"):
		navePlayer.getEscudo().controlarEnergiaEscudo(radioEntregaEnergia * 5)
	
	if event.is_action_released("recargarBeam"):
		Eventos.emit_signal("actualizarEnergiaLaser")
	elif event.is_action_released("recargarEscudo"):
		Eventos.emit_signal("ocultarInfoEnergiaEscudo")


func _on_AreaRecarga_body_entered(body: Node) -> void:
	if body is Player:
		navePlayer = body
		Eventos.emit_signal("detectoZonaRecarga", true)
	playerEnArea = true
	

func _on_AreaRecarga_body_exited(body: Node) -> void:
	playerEnArea = false
	Eventos.emit_signal("detectoZonaRecarga", false)


func _on_AreaEstacionFisica_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func puedeRecargar(event: InputEvent) -> bool:
	var hayInput = event.is_action("recargarBeam") or event.is_action("recargarEscudo")
	if hayInput and playerEnArea and energiaEstacion > 0.0: 
		if !recargaSFX.playing:
			recargaSFX.play()
		return true
	recargaSFX.stop()
	return false


func controlarEnergia() -> void:
	energiaEstacion -= radioEntregaEnergia
	alertaVacio()

	
func alertaVacio() -> void:
	if energiaEstacion <= 0:
		if !vacioSFX.playing:
			vacioSFX.play()
			yield(get_tree().create_timer(1.95), "timeout")
