class_name Dummy
extends Node2D


var hitPoints:float = 10.0


func _process(delta: float) -> void:
	$Canion.setEstaDisparando(true)


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		body.destruir()

func recibirDanio(danio: float) -> void:
	hitPoints -= danio
	if hitPoints <= 0.0:
		queue_free()
