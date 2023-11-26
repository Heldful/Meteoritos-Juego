class_name Minimapa
extends MarginContainer

export var tiempoVisible:float = 4.0
export var escalaZoom:float = 4.0
var escalaGrilla:Vector2
var player:Player = null
var estaVisible:bool = false setget set_estaVisible

onready var timerVisibilidad:Timer = $TimerVisibilidad
onready var tweenVisibilidad:Tween = $TweenVisibilidad
onready var zonaRenderizado:TextureRect = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa
onready var iconoPlayer:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoPlayer
onready var iconoBase:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoBaseEnemiga
onready var iconoEstacion:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoEstacionRecarga
onready var iconoRele:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoRele
onready var iconoInterceptor:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoInterceptor
onready var itemsMiniMapa:Dictionary = {}


func _ready() -> void:
	
	set_process(false)
	timerVisibilidad.wait_time = tiempoVisible
	ajustarGrilla()
	conectarSeniales()


func _process(delta: float) -> void:
	if not player:
		return
	
	iconoPlayer.rotation_degrees = player.rotation_degrees + 90
	modificarPosicionIconos()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("minimapa"):
		set_estaVisible(not estaVisible)


func set_estaVisible(hacerVisible: bool) -> void:
	if hacerVisible:
		timerVisibilidad.start()
		
	estaVisible = hacerVisible
	
	tweenVisibilidad.interpolate_property(
		self,
		"modulate",
		Color(1, 1, 1, not hacerVisible),
		Color(1, 1, 1, hacerVisible),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	tweenVisibilidad.start()


func ajustarGrilla() -> void:
	iconoPlayer.position = zonaRenderizado.rect_size * 0.5
	escalaGrilla = zonaRenderizado.rect_size / (get_viewport_rect().size * escalaZoom)


func conectarSeniales() -> void:
	Eventos.connect("nivelIniciado", self, "_on_nivelIniciado")
	Eventos.connect("naveDestruida", self, "_on_naveDestruida")
	Eventos.connect("minimapaObjetoCreado", self, "obtenerObjetosMinimapa")
	Eventos.connect("minimapaObjetoDestruido", self, "quitarIcono")


func obtenerObjetosMinimapa() -> void:
	var objetosVentana:Array = get_tree().get_nodes_in_group("minimapa")
	print(objetosVentana)
	for objeto in objetosVentana:
		if not itemsMiniMapa.has(objeto):
			var spriteIcono: Sprite
			if objeto is BaseEnemiga:
				spriteIcono = iconoBase.duplicate()
			elif objeto is EstacionRecarga:
				spriteIcono = iconoEstacion.duplicate()
			elif objeto is ReleMasa:
				spriteIcono = iconoRele.duplicate()
			elif objeto is EnemigoInterceptor:
				spriteIcono = iconoInterceptor.duplicate()
			
			itemsMiniMapa[objeto] = spriteIcono
			itemsMiniMapa[objeto].visible = true
			zonaRenderizado.add_child(itemsMiniMapa[objeto])


func modificarPosicionIconos() -> void:
	for item in itemsMiniMapa:
		var itemIcono:Sprite = itemsMiniMapa[item]
		var offsetPos:Vector2 = item.position - player.position
		var posIcono:Vector2 = offsetPos * escalaGrilla + (zonaRenderizado.rect_size * 0.5)
		posIcono.x = clamp(posIcono.x, 0, zonaRenderizado.rect_size.x)
		posIcono.y = clamp(posIcono.y, 0, zonaRenderizado.rect_size.y)
		itemIcono.position = posIcono
		
		if zonaRenderizado.get_rect().has_point(posIcono - zonaRenderizado.rect_position):
			itemIcono.scale = Vector2(0.5, 0.5)
		else:
			itemIcono.scale = Vector2(0.3, 0.3)


func quitarIcono(objeto: Node2D) -> void:
	if objeto in itemsMiniMapa:
		itemsMiniMapa[objeto].queue_free()
		itemsMiniMapa.erase(objeto)


func _on_nivelIniciado() -> void:
	player = DatosJuego.getPlayerActual()
	obtenerObjetosMinimapa()
	set_process(true)


func _on_naveDestruida(nave: NaveBase, _posicion, _explosiones) -> void:
	set_estaVisible(false)
	if nave is Player:
		player = null


func _on_TimerVisibilidad_timeout() -> void:
	if estaVisible:
		set_estaVisible(false)
