class_name CamaraPlayer
extends CamaraJuego


export var variacionZoom:float = -1
export var valorMaximoZoom:float = 1
export var valorMinimoZoom:float = 1.6


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoomIn") and puedeHacerZoom:
		print("me acerco", zoom)
		controlarZoom(-variacionZoom)
		print(zoom)
	elif event.is_action_pressed("zoomOut") and puedeHacerZoom:
		print("me alejo",zoom)
		controlarZoom(variacionZoom)
		print(zoom)


func controlarZoom(modZoom: float) -> void:
	var zoomX = clamp(zoom.x + modZoom, valorMinimoZoom, valorMaximoZoom)
	var zoomY = clamp(zoom.y + modZoom, valorMinimoZoom, valorMaximoZoom)
	zoomSuavizado(zoomX, zoomY, 0.15)
