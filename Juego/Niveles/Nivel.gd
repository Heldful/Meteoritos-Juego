class_name Nivel
extends Node

export var tiempoLimite:int = 10
export var releMasa:PackedScene = null
export var sectorMeteoritos:PackedScene = null
export var enemigoOrbital:PackedScene = null
export var enemigoInterceptor:PackedScene = null
export var explosionMeteorito:PackedScene = null
export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var tiempoTransicionCamara:float = 3.0
var meteoritosTotales:int = 0
var playerActual:Player = null
var numeroBasesEnemigas:int = 0
var zoomPrevio

onready var contenedorProyectiles:Node
onready var contenedorMeteoritos:Node
onready var contenedorSectorMeteoritos:Node
onready var contenedorEnemigos: Node
onready var camaraNivel:Camera2D = $CamaraNivel
onready var actualizarTimer:Timer = $ActualizadorTimer



func _ready() -> void:
	actualizarTimer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	playerActual = DatosJuego.getPlayerActual()
	Eventos.emit_signal("nivelIniciado")
	Eventos.emit_signal("actualizarTiempo", tiempoLimite)
	numeroBasesEnemigas = contabilizarBasesEnemigas()
	crearContenedores()
	conectarSeniales()


func conectarSeniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")
	Eventos.connect("naveDestruida", self, "_on_naveDestruida")
	Eventos.connect("baseDestruida", self, "_on_baseDestruida")
	Eventos.connect("naveEnSectorDePeligro", self, "_on_naveEnSectorDePeligro")
	Eventos.connect("spawnMeteorito", self, "_on_spawnMeteorito")
	Eventos.connect("explosionMeteorito", self, "_on_explosionMeteorito")
	Eventos.connect("spawnEnemigoOrbital", self, "_on_spawnEnemigoOrbital")


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
	
	contenedorEnemigos = Node.new()
	contenedorEnemigos.name = "ContenedorEnemigos"
	add_child(contenedorEnemigos)


func crearSectorMeteoritos(centroCamara: Vector2, numeroPeligros: int) -> void:
	meteoritosTotales = numeroPeligros
	
	var newSectorMeteoritos = sectorMeteoritos.instance()
	
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


func crearSectorEnemigos(numeroEnemigos: int) -> void:
	for _i in range(numeroEnemigos):
		var newInterceptor: EnemigoInterceptor = enemigoInterceptor.instance()
		var posicionSpawn:Vector2 = crearPosicionAleatoria(1000.0, 800.0)
		newInterceptor.global_position = playerActual.global_position + posicionSpawn
		contenedorEnemigos.add_child(newInterceptor)


func crearReleMasa() -> void:
	if playerActual == null:
		return
	
	var newReleMasa:ReleMasa = releMasa.instance()
	var posicionAleatoria = crearPosicionAleatoria(400.0, 200.0)
	var margen:Vector2 = Vector2(600.0, 600.0)
	
	if posicionAleatoria.x < 0:
		margen.x *= -1
	if posicionAleatoria.y < 0:
		margen.y *= -1
	
	newReleMasa.global_position = playerActual.global_position + (margen + posicionAleatoria)
	add_child(newReleMasa)


func controlarMeteoritos() -> void:
	meteoritosTotales -= 1
	Eventos.emit_signal("cambioNumeroMeteorito", meteoritosTotales)
	
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


func crearExplosion(
	posicion:Vector2,
	numero: int = 1,
	intervalo: float = 0.0,
	rangosAleatorios: Vector2 = Vector2(0.0, 0.0),
	tamanio: Vector2 = Vector2(0.6, 1.2)
) -> void:
	var tamanioMinimo = tamanio.x
	var tamanioMaximo = tamanio.y
	for _i in range(numero):
		var newExplosion:Node2D = explosion.instance()
		newExplosion.scale = vectorAleatorioProporcionado(tamanioMinimo, tamanioMaximo)
		newExplosion.global_position = posicion + crearPosicionAleatoria(
			rangosAleatorios.x,
			rangosAleatorios.y
			)
		add_child(newExplosion)
		yield(get_tree().create_timer(intervalo), "timeout")


func camaraDestruccion() -> void:
	var camaraJugador:Camera2D  = $Player/CamaraPlayer
	
	camaraNivel.global_position = camaraJugador.global_position
	camaraNivel.zoom = camaraJugador.zoom
	camaraNivel.current = true


func crearPosicionAleatoria(rangoHorizontal: float,
 rangoVertical: float) -> Vector2:
	randomize()
	var randomX = rand_range(-rangoHorizontal, rangoVertical)
	var randomY = rand_range(-rangoVertical, rangoVertical)
	
	return Vector2(randomX, randomY)


func vectorAleatorioProporcionado(numeroMinimo: float, numeroMaximo: float) -> Vector2:
	randomize()
	var numeroAleatorio = rand_range(numeroMinimo, numeroMaximo)
	return Vector2(numeroAleatorio, numeroAleatorio)


func contabilizarBasesEnemigas() -> int:
	return $ContenedorBasesEnemigas.get_child_count()


func destruirNivel() -> void:
	crearExplosion(
		playerActual.global_position,
		2,
		0.5,
		Vector2(300.0, 200.0),
		Vector2(10,20)
	)
	playerActual.destruir()


func _on_disparo(proyectil:Proyectil) -> void:
	contenedorProyectiles.add_child(proyectil)


func _on_naveDestruida(nave:Player, posicion: Vector2, numExplosiones: int) -> void:
	if nave is Player:
		camaraDestruccion()
		$RestartTimer.start()
		get_tree().call_group("contenedorInfo", "set_estaActivo", false)
		get_tree().call_group("contenedorInfo", "ocultar") 
	
	crearExplosion(posicion, numExplosiones, 0.6, Vector2(100, 50))
	

func _on_baseDestruida(_base, posicionPartes: Array) -> void:
	for posicion in posicionPartes:
		crearExplosion(posicion)
		yield(get_tree().create_timer(0.5), "timeout")
	
	numeroBasesEnemigas -= 1
	print("bases restantes: ", numeroBasesEnemigas)
	if numeroBasesEnemigas == 0:
		crearReleMasa()


func _on_naveEnSectorDePeligro(centroCam:Vector2, tipoPeligro:String,
numPeligros:int) -> void:
	if tipoPeligro == "Meteorito":
		crearSectorMeteoritos(centroCam, numPeligros)
		Eventos.emit_signal("cambioNumeroMeteorito", numPeligros)
	elif tipoPeligro == "Enemigo":
		crearSectorEnemigos(numPeligros)


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


func _on_spawnEnemigoOrbital(orbital: EnemigoOrbital) -> void:
	contenedorEnemigos.add_child(orbital)


func _on_TweenCamara_tween_completed(object: Object, key: NodePath) -> void:
	if object.name == "CamaraPlayer":
		object.global_position = $Player.global_position


func _on_RestartTimer_timeout() -> void:
	Eventos.emit_signal("nivelTerminado")
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().reload_current_scene()


func _on_ActualizadorTimer_timeout() -> void:
	tiempoLimite -= 1
	Eventos.emit_signal("actualizarTiempo", tiempoLimite)
	if tiempoLimite == 0:
		destruirNivel()
