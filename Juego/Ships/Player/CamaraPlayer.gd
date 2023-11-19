class_name CamaraPlayer
extends CamaraJuego


export var variacionZoom:float = -1
export var valorMaximoZoom:float = 1
export var valorMinimoZoom:float = 1.6


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoomIn") and puedeHacerZoom:
		controlarZoom(-variacionZoom)
	elif event.is_action_pressed("zoomOut") and puedeHacerZoom:
		controlarZoom(variacionZoom)


func controlarZoom(modZoom: float) -> void:
	var zoomX = clamp(zoom.x + modZoom, valorMinimoZoom, valorMaximoZoom)
	var zoomY = clamp(zoom.y + modZoom, valorMinimoZoom, valorMaximoZoom)
	zoomSuavizado(zoomX, zoomY, 0.15)
