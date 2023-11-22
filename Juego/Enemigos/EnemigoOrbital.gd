class_name EnemigoOrbital
extends EnemigoBase


export var rangoMaximoAtaque:float = 1400.0
export var velocidad:float = 400.0
var estacionOwner:Node2D
var ruta:Path2D
var pathFollow:PathFollow2D 

onready var detectorObstaculo:RayCast2D = $DetectorObstaculo


func _ready() -> void:
	Eventos.connect("baseDestruida", self, "_on_baseDestruida")
	canion.setEstaDisparando(true)


func _process(delta: float) -> void:
	pathFollow.offset += velocidad * delta
	position = pathFollow.global_position


func crear(posicion: Vector2, owner: Node2D, rutaOwner: Path2D) -> void:
	global_position = posicion
	estacionOwner = owner
	ruta = rutaOwner
	
	pathFollow = PathFollow2D.new()
	ruta.add_child(pathFollow)


func rotarHaciaPlayer() -> void:
	.rotarHaciaPlayer()
	if playerDireccion.length() > rangoMaximoAtaque or detectorObstaculo.is_colliding():
		canion.setEstaDisparando(false)
	else:
		canion.setEstaDisparando(true)


func _on_baseDestruida(base: Node2D, _pos) -> void:
	if base == estacionOwner:
		destruir()
