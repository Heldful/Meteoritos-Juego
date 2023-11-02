extends RigidBody2D


export var potenciaMotor:int = 500
export var potenciaRotacion:int = 280


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	pass


func _process(delta: float) -> void:
	inputPlayer()


func inputPlayer() -> void:
	var empuje = Vector2.ZERO
	var direccionRotacion = 0
	
	
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potenciaMotor, 0)
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potenciaMotor, 0)
	
	if Input.is_action_pressed("girar_horario"):
		direccionRotacion += potenciaRotacion
	elif Input.is_action_pressed("girar_antihorario"):
		direccionRotacion -= potenciaRotacion
