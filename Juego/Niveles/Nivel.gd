class_name Nivel
extends Node

export var SectorMeteoritos:PackedScene = null
export var explosionMeteorito:PackedScene = null
export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var tiempoTransicionCamara:float = 3.0

var meteoritosTotales:int = 0
var zoomPrevio

onready var contenedorProyectiles:Node
onready var contenedorMeteoritos:Node
onready var contenedorSectorMeteoritos:Node
onready var camaraNivel:Camera2D = $CamaraNivel

func _ready() -> void:
	crearContenedores()
	conectarSeniales()
	print("Posicion camara onready: ", $Player/CamaraPlayer.global_position)

func conectarSeniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")
	Eventos.connect("naveDestruida", self, "_on_naveDestruida")
	Eventos.connect("naveEnSectorDePeligro", self, "on_naveEnSectorDePeligro")
	Eventos.connect("spawnMeteorito", self, "_on_spawnMeteorito")
	Eventos.connect("explosionMeteorito", self, "_on_explosionMeteorito")


func crearContenedores() -> void:
	contenedorProyectiles = Node.new()
	contenedorProyectiles.name = "ContenedorProyectiles"
	add_child(contenedorProyectiles)
	
	contenedorMeteoritos = Node.new()
	contenedorMeteoritos.name = "ContenedorMeteoritos"
	add_child(contenedorMeteoritos)
	
	contenedorSectorMeteoritos = Node.new()
	contenedorSectorMeteoritos.name = "ContenedorSectorMeteoritos"
	add_child(contenedorSectorMeteoritos)


func _on_disparo(proyectil:Proyectil) -> void:
	contenedorProyectiles.add_child(proyectil)


func _on_naveDestruida(posicion: Vector2, numExplosiones: int) -> void:
	for i in range(numExplosiones):
		var newExplosion:Node2D = explosion.instance()
		newExplosion.global_position = posicion
		add_child(newExplosion)
		yield(get_tree().create_timer(0.6), "timeout")


func on_naveEnSectorDePeligro(centroCam:Vector2, tipoPeligro:String,
numPeligros:int) -> void:
	if tipoPeligro == "Meteorito":
		crearSectorMeteoritos(centroCam, numPeligros)
	elif tipoPeligro == "Enemigo":
		pass


func _on_spawnMeteorito(posSpawn: Vector2, dirMeteorito: Vector2,
 tamanio: float) -> void:
	var newMeteorito: Meteorito = meteorito.instance()
	newMeteorito.crear(posSpawn, dirMeteorito, tamanio)
	contenedorMeteoritos.add_child(newMeteorito)


func _on_explosionMeteorito(posExplosion: Vector2) -> void:
	var newExplosionMeteorito:ExplosionMeteorito = explosionMeteorito.instance()
	newExplosionMeteorito.global_position = posExplosion
	add_child(newExplosionMeteorito)
	
	controlarMeteoritos()


func crearSectorMeteoritos(centroCamara: Vector2, numeroPeligros: int) -> void:
	
	meteoritosTotales = numeroPeligros
	var newSectorMeteoritos = SectorMeteoritos.instance()
	newSectorMeteoritos.crear(centroCamara, numeroPeligros)
	$Player/CamaraPlayer.setPuedeHacerZoom(false)
	zoomPrevio = $Player/CamaraPlayer.zoom
	camaraNivel.global_position = centroCamara
	contenedorSectorMeteoritos.add_child(newSectorMeteoritos)
	var zoomPrevioNivel = camaraNivel.zoom
	camaraNivel.zoom = zoomPrevio
	camaraNivel.zoomSuavizado(zoomPrevioNivel.x, zoomPrevioNivel.y, 2.0)
	transicionCamara(
		$Player/CamaraPlayer.global_position,
		camaraNivel.global_position,
		camaraNivel,
		tiempoTransicionCamara
	)
	

func controlarMeteoritos() -> void:
	meteoritosTotales -= 1
	

	if meteoritosTotales == 0:
		contenedorSectorMeteoritos.get_child(0).queue_free()
		$Player/CamaraPlayer.setPuedeHacerZoom(true)
		$Player/CamaraPlayer.zoomSuavizado(zoomPrevio.x, zoomPrevio.y, 2.0)
		transicionCamara(
			camaraNivel.global_position,
			$Player/CamaraPlayer.global_position,
			$Player/CamaraPlayer,
			tiempoTransicionCamara * 0.10
		)
		


func transicionCamara(
	desde: Vector2, 
	hasta: Vector2,
	camaraActual: Camera2D,
	tiempoTransicion: float) -> void:
	$TweenCamara.interpolate_property(
		camaraActual,
		"global_position",
		desde,
		hasta,
		tiempoTransicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	camaraActual.current = true
	$TweenCamara.start()


func _on_TweenCamara_tween_completed(object: Object, key: NodePath) -> void:
	if object.name == "CamaraPlayer":
		object.global_position = $Player.global_position

