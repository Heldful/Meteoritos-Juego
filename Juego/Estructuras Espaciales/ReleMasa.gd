class_name ReleMasa
extends Node2D


func _ready() -> void:
	Eventos.emit_signal("minimapaObjetoCreado")


func atraePlayer(body: Node) -> void:
	$Tween.interpolate_property(
		body,
		"global_position",
		body.global_position,
		global_position,
		1.0,
		Tween.TRANS_CIRC,
		Tween.EASE_IN
	)
	$Tween.start()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		$AnimationPlayer.play("activada")


func _on_DetectorPlayer_body_entered(body: Node) -> void:
	$DetectorPlayer/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("superActivado")
	body.desactivarControles()
	atraePlayer(body)

func _on_Tween_tween_all_completed() -> void:
	print("next lvl")
