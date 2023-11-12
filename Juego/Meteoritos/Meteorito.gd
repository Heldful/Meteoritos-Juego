class_name Meteorito
extends RigidBody2D


export var velocidadLinealBase:Vector2 = Vector2(300.0, 300.0)
export var velocidadAngularBase:float = 3.0
export var hitPointsBase:float = 10.0

var hitPoints:float 
var estaEnSector:bool setget setEstaEnSector
var estaDestruido:bool = false
var posSpawnOriginal:Vector2 
var velSpawnOriginal:Vector2

onready var meteoritoImpactadoSfx:AudioStreamPlayer2D = $MeteoritoImpactadoSFX
onready var animacion:AnimationPlayer = $AnimationPlayer


func setEstaEnSector(valor: bool) -> void:
	estaEnSector = valor


func crear(pos: Vector2, dir: Vector2, tamanio: float) -> void:
	position = pos
	posSpawnOriginal = position
	
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	var radio:int = int($Sprite.texture.get_size().x / 2.3 * tamanio) #radio = diametro/2
	var formaColision:CircleShape2D = CircleShape2D.new()
	formaColision.radius = radio
	$CollisionShape2D.shape = formaColision
	
	linear_velocity = (velocidadLinealBase * dir / tamanio) * randomizarVelocidad()
	velSpawnOriginal = linear_velocity
	angular_velocity = (velocidadAngularBase / tamanio) * randomizarVelocidad()
	
	hitPoints = hitPointsBase * tamanio
	
	print("HitPoints: ", hitPoints)


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if estaEnSector:
		return
	
	var miTransform := state.get_transform()
	miTransform.origin = posSpawnOriginal
	linear_velocity = velSpawnOriginal
	state.set_transform(miTransform)
	estaEnSector = true

func recibirDanio(danio) -> void:
	hitPoints -= danio
	meteoritoImpactadoSfx.play()
	animacion.play("impacto")
	if hitPoints <= 0.0 and not estaDestruido:
		estaDestruido = true
		destruir()


func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("explosionMeteorito", global_position)
	queue_free()


func randomizarVelocidad() -> float:
	randomize()
	return rand_range(1.1, 1.4)
