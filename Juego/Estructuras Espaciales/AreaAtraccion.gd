class_name AreaRecarga 
extends Area2D


func _on_body_entered(body: Node) -> void:
	body.set_gravity_scale(0.15)


func _on_body_exited(body: Node) -> void:
	body.set_gravity_scale(0.0)
