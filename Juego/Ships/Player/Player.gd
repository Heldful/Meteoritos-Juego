extends RigidBody2D


export var potenciaMotor:int = 100
export var potenciaRotacion:int = 280

var empuje
var direccionRotacion


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	print(empuje.rotated(rotation))
	print(rad2deg(rotation))
	
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(potenciaRotacion * direccionRotacion)


func _process(delta: float) -> void:
	inputPlayer()


func inputPlayer() -> void:
	empuje = Vector2.ZERO
	direccionRotacion = 0
	
	
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potenciaMotor, 0)
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potenciaMotor, 0)
	
	if Input.is_action_pressed("girar_horario"):
		direccionRotacion += 1
	elif Input.is_action_pressed("girar_antihorario"):
		direccionRotacion -= 1
