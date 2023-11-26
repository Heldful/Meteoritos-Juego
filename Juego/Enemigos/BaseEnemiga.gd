class_name BaseEnemiga
extends Node2D

export var baseEnemigaHitpoints:float = 30
export var orbital:PackedScene = null
export var numeroOrbitales:int = 10
export var intervaloSpawn:float = 0.8
var estaDestruida:bool = false
var posicionSpawn:Vector2

onready var impactoSFX:AudioStreamPlayer2D = $ImpactoSFX
onready var timerSpawner:Timer = $TimerSpawnOrbitales


func _ready() -> void:
	timerSpawner.wait_time = intervaloSpawn


func _process(delta: float) -> void:
	correrAnimacionBase()


func recibirDanio(danio: float) -> void:
	#print("Recibe danio. Cantidad: ", danio)
	baseEnemigaHitpoints -= danio
	#print("HP restantes:", baseEnemigaHitpoints)
	impactoSFX.play()
	
	if baseEnemigaHitpoints <= 0.0 and not estaDestruida:
		destruir()
		estaDestruida = true


func destruir() -> void:
	var posicionesPartes = [
		$Sprites/Sprite.global_position,
		$Sprites/Sprite2.global_position,
		$Sprites/Sprite3.global_position,
		$Sprites/Sprite4.global_position,
		$Sprites/Sprite5.global_position,
		$Sprites/Sprite6.global_position,
		$Sprites/Sprite7.global_position,
		$Sprites/Sprite8.global_position,
		$Sprites/Sprite9.global_position
	]
	Eventos.emit_signal("minimapaObjetoDestruido", self)
	Eventos.emit_signal("baseDestruida", self, posicionesPartes)
	queue_free()


func elegirAnimacionAleatoria() -> String:
	randomize()
	var numeroAnimaciones:int = $AnimationPlayer.get_animation_list().size() - 1
	var indiceAnimacionAleatoria:int = randi() % numeroAnimaciones + 1
	var listaAnimaciones:Array = $AnimationPlayer.get_animation_list()
	return listaAnimaciones[indiceAnimacionAleatoria] 


func correrAnimacionBase() -> void:
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play(elegirAnimacionAleatoria())


func deteccionCuadrante() -> Vector2:
	var playerObjetivo:Player = DatosJuego.getPlayerActual()
	
	if not playerObjetivo:
		return Vector2.ZERO
	
	var direccionPlayer:Vector2 = playerObjetivo.global_position - global_position
	var anguloPlayer:float = rad2deg(direccionPlayer.angle())
	
	#Este
	if abs(anguloPlayer) <= 45.0:
		$OrbitalesRuta.rotation_degrees = 180.0
		return $PosicionesSpawn/Este.global_position
	#Oeste
	elif abs(anguloPlayer) > 135.0 and abs(anguloPlayer) <= 180.0:
		$OrbitalesRuta.rotation_degrees = 0.0
		return $PosicionesSpawn/Oeste.global_position
	#Norte y sur
	elif abs(anguloPlayer) > 45.0 and abs(anguloPlayer) <= 135.0:
		#Sur
		if sign(anguloPlayer) > 0:
			$OrbitalesRuta.rotation_degrees = 270.0
			return $PosicionesSpawn/Sur.global_position
		#Norte
		else:
			$OrbitalesRuta.rotation_degrees = 90.0
			return $PosicionesSpawn/Norte.global_position
	
	return $PosicionesSpawn/Norte.global_position


func spawnearOrbital() -> void:
	numeroOrbitales -= 1
	
	$OrbitalesRuta.global_position = global_position
	
	var newEnemigoOrbital:EnemigoOrbital = orbital.instance()
	
	newEnemigoOrbital.crear(
		global_position + posicionSpawn, 
		self,
		$OrbitalesRuta
	)
	Eventos.emit_signal("spawnEnemigoOrbital", newEnemigoOrbital)


func _on_AreaColisionFisica_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	posicionSpawn = deteccionCuadrante()
	deteccionCuadrante()
	spawnearOrbital()
	timerSpawner.start()


func _on_TimerSpawnOrbitales_timeout() -> void:
	if numeroOrbitales == 0:
		timerSpawner.stop()
		return
	spawnearOrbital()
