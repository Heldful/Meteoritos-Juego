class_name CamaraJuego
extends Camera2D


var zoomOriginal:Vector2
var puedeHacerZoom:bool = true setget setPuedeHacerZoom

onready var tweenZoom:Tween = $TweenZoom


func _ready() -> void:

	zoomOriginal = zoom


func setPuedeHacerZoom(valor: bool) -> void:
	puedeHacerZoom = valor


func devolverZoomOriginal() -> void:
	puedeHacerZoom = false
	zoomSuavizado(zoomOriginal.x, zoomOriginal.y, 1.5)


func zoomSuavizado(nuevoZoomX: float, nuevoZoomY: float,
 tiempoTransicion) -> void:
	tweenZoom.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(nuevoZoomX, nuevoZoomY),
		tiempoTransicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tweenZoom.start()
