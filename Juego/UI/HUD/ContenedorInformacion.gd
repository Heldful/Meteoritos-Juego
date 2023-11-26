class_name ContenedorInformacion
extends NinePatchRect


export var autoOcultar:bool = false setget set_autoOcultar
var estaActivo:bool = true setget set_estaActivo

onready var animacion:AnimationPlayer = $AnimationPlayer
onready var textoContenedor:Label = $Label
onready var autoOcultarTimer:Timer = $AutoOcultarTimer


func set_autoOcultar(ocultar) -> void:
	autoOcultar = ocultar


func set_estaActivo(valor: bool) -> void:
		estaActivo = valor


func mostrar() -> void:
	if estaActivo:
		animacion.play("mostrar")


func ocultar() -> void:
	if not estaActivo:
		animacion.stop()
	animacion.play("ocultar")



func mostrarSuavizado() -> void:
	if estaActivo:
		animacion.play("mostrarSuavizado")
	if autoOcultar:
		autoOcultarTimer.start()


func ocultarSuavizado() -> void:
	if estaActivo:
		animacion.play("ocultarSuavizado")


func modificarTexto(text: String) -> void:
	textoContenedor.text = text


func _on_AutoOcultarTimer_timeout() -> void:
	ocultarSuavizado()
