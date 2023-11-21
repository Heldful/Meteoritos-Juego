class_name BaseEnemiga
extends Node2D

export var orbital:PackedScene = null
export var baseEnemigaHitpoints:float = 30
var estaDestruida:bool = false

onready var impactoSFX:AudioStreamPlayer2D = $ImpactoSFX


func _process(delta: float) -> void:
	correrAnimacionBase()
	deteccionCuadrante()


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
		 return $PosicionesSpawn/Este.global_position
	#Oeste
	elif abs(anguloPlayer) > 135.0 and abs(anguloPlayer) <= 180.0:
		return $PosicionesSpawn/Oeste.global_position
	#Norte y sur
	elif abs(anguloPlayer) > 45.0 and abs(anguloPlayer) <= 135.0:
		#Sur
		if sign(anguloPlayer) > 0:
			return $PosicionesSpawn/Sur.global_position
		#Norte
		else:
			return $PosicionesSpawn/Norte.global_position
	
	return $PosicionesSpawn/Norte.global_position


func spawnearOrbital() -> void:
	var posicionSpawn = deteccionCuadrante()
	var newEnemigoOrbital:EnemigoOrbital = orbital.instance()
	
	newEnemigoOrbital.crear(
		global_position + posicionSpawn, 
		self
	)
	Eventos.emit_signal("spawnEnemigoOrbital", newEnemigoOrbital)


func _on_AreaColisionFisica_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	spawnearOrbital()

