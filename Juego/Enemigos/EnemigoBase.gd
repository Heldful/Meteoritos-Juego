class_name EnemigoBase
extends NaveBase


func _ready() -> void:
	canion.setEstaDisparando(true)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controladorEstados(Estado.VIVO)


func _on_Player_body_entered(body: Node) -> void:
	._on_Player_body_entered(body)
	if body is Player:
		body.destruir()
		destruir()
