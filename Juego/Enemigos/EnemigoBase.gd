class_name EnemigoBase
extends NaveBase


var playerObjetivo: Player = null
var playerDireccion:Vector2
var frameActual:int = 0


func _ready() -> void:
	playerObjetivo = DatosJuego.getPlayerActual()
	Eventos.connect("naveDestruida", self, "_on_naveDestruida")


func _physics_process(delta: float) -> void:
	if playerObjetivo == null:
		canion.setEstaDisparando(false)
		return
	frameActual += 1
	if frameActual % 3 == 0:
	 rotarHaciaPlayer()


func rotarHaciaPlayer() -> void:
	if playerObjetivo:
		playerDireccion = playerObjetivo.global_position - global_position
		rotation = playerDireccion.angle()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controladorEstados(Estado.VIVO)


func _on_naveDestruida(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Player:
		playerObjetivo = null
	if nave.is_in_group("minimapa"):
		Eventos.emit_signal("minimapaObjetoDestruido", nave)


func _on_Player_body_entered(body: Node) -> void:
	._on_Player_body_entered(body)
	if body is Player:
		body.destruir()
		destruir()
