class_name Proyectil
extends Area2D


var velocidad:Vector2 = Vector2.ZERO
var danio:float


func crear(pos: Vector2, dir: float, vel: float, danioP: int):
	position = pos
	rotation = dir
	velocidad = Vector2(vel, 0).rotated(dir)


func _physics_process(delta: float) -> void:
	position += velocidad * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
