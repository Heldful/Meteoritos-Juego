class_name EnemigoBase
extends NaveBase


var playerObjetivo: Player = null
var playerDireccion:Vector2


func _ready() -> void:
	playerObjetivo = DatosJuego.getPlayerActual()


func _physics_process(delta: float) -> void:
	if playerObjetivo == null:
		canion.setEstaDisparando(false)
		return
	rotarHaciaPlayer()


func rotarHaciaPlayer() -> void:
	if playerObjetivo:
		playerDireccion = playerObjetivo.global_position - global_position
		rotation = playerDireccion.angle()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controladorEstados(Estado.VIVO)


func _on_Player_body_entered(body: Node) -> void:
	._on_Player_body_entered(body)
	if body is Player:
		body.destruir()
		destruir()
