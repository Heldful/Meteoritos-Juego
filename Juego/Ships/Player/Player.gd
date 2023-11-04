class_name Player
extends RigidBody2D


enum Estado {VIVO, MUERTO, SPAWN, INVENCIBLE}

export var potenciaMotor:int = 100
export var potenciaRotacion:int = 280
export var trailMaximo:int = 150

var estadoActual:int = Estado.SPAWN
var empuje
var direccionRotacion

onready var canion:Canion = $Canion
onready var laserBeam:LaserBeam = $LaserBeam2D
onready var trail:Trail = $TrailPuntoInicio/Trail2D
onready var motorSFX:Motor = $MotorSFX
onready var colisionador:CollisionShape2D = $CollisionShape2D


func controladorEstados(nuevoEstado: int) ->void:
	match nuevoEstado:
		Estado.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.setPuedeDisparar(false)
		Estado.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.setPuedeDisparar(true)
		Estado.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		Estado.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.setPuedeDisparar(false)
			
			#explotar()
			queue_free()
		_:
			print("Error")
	estadoActual = nuevoEstado


func _unhandled_input(event: InputEvent) -> void:
	if not estaInputActivo():
		return 
	
	if event.is_action_pressed("disparoSecundario"):
		laserBeam.set_is_casting(true)
	if event.is_action_released("disparoSecundario"):
		laserBeam.set_is_casting(false)
	
	if event.is_action_pressed("mover_adelante"):
		trail.setMaxPoints(trailMaximo)
		motorSFX.sonidoOn()
	elif event.is_action_pressed("mover_atras"):
		trail.setMaxPoints(0)
		motorSFX.sonidoOn()
		
	if (event.is_action_released("mover_adelante")
	or event.is_action_released("mover_atras")):
		motorSFX.sonidoOff()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if empuje != null:
		apply_central_impulse(empuje.rotated(rotation))
		apply_torque_impulse(potenciaRotacion * direccionRotacion)


func _ready() -> void:
	controladorEstados(estadoActual)


func _process(delta: float) -> void:
	inputPlayer()


func inputPlayer() -> void:
	if not estaInputActivo():
		return 
	
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
	
	if Input.is_action_pressed("disparoPrincipal"):
		canion.setEstaDisparando(true)
	if Input.is_action_just_released("disparoPrincipal"):
		canion.setEstaDisparando(false)


func estaInputActivo() -> bool:
	if estadoActual in [Estado.MUERTO, Estado.SPAWN]:
		return false
	return true


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controladorEstados(Estado.VIVO)
