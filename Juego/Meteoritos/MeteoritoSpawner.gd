class_name MeteoritoSpawner
extends Position2D


export var direccion:Vector2 = Vector2(1, 1)
export var rangoTamanioMeteorito:Vector2 = Vector2(0.5, 2.2)


func _ready() -> void:
	yield(owner, "ready")


func spawnearMeteorito() -> void:
	Eventos.emit_signal("spawnMeteorito", 
	global_position, 
	direccion, 
	tamanioMeteoritoAleatorio()
	)


func tamanioMeteoritoAleatorio() -> float:
	randomize()
	return rand_range(rangoTamanioMeteorito[0], rangoTamanioMeteorito[1])
