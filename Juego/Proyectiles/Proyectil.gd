class_name Proyectil
extends Area2D


var velocidad:Vector2 = Vector2.ZERO
var danio:float = 1.0


func crear(pos: Vector2, dir: float, vel: float, danioP: float):
	position = pos
	rotation = dir
	danio = danioP
	velocidad = Vector2(vel, 0).rotated(dir)


func _physics_process(delta: float) -> void:
	position += velocidad * delta


func daniar(otroCuerpo: CollisionObject2D) -> void:
	if otroCuerpo.has_method("recibirDanio"):
		print("El danio es de:", danio)
		otroCuerpo.recibirDanio(danio)
		queue_free()


func _on_Proyectil_area_entered(area: Area2D) -> void:
	daniar(area)


func _on_Proyectil_body_entered(body: Node) -> void:
	print("Proyectil colisiona rigidBody2D")
	daniar(body)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
