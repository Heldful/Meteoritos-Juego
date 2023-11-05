class_name Proyectil
extends Area2D


var velocidad:Vector2 = Vector2.ZERO
var danio:float = 1.0


func crear(pos: Vector2, dir: float, vel: float, danioP: int):
	position = pos
	rotation = dir
	velocidad = Vector2(vel, 0).rotated(dir)


func _physics_process(delta: float) -> void:
	position += velocidad * delta


func daniar(otroCuerpo: CollisionObject2D) -> void:
	if otroCuerpo.has_method("recibirDanio"):
		otroCuerpo.recibirDanio(danio)
	queue_free()


func _on_Proyectil_area_entered(area: Area2D) -> void:
	daniar(area)


func _on_Proyectil_body_entered(body: Node) -> void:
	daniar(body)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
