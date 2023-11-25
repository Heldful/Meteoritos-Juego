class_name HUD
extends CanvasLayer


onready var infoZonaRecarga:ContenedorInformacion = $InfoZonaRecarga
onready var infoMeteoritos:ContenedorInformacion = $InfoMeteoritos
onready var infoTiempoRestante:ContenedorInformacion = $InfoTiempoRestante
onready var infoEnergiaLaser:ContenedorInformacionEnergia = $InfoEnergiaLaser
onready var infoEnergiaEscudo:ContenedorInformacionEnergia = $InfoEnergiaEscudo


func _ready() -> void:
	conectarSenialesHUD()


func conectarSenialesHUD() -> void:
	Eventos.connect("nivelIniciado", self, "fadeOut")
	Eventos.connect("nivelTerminado", self, "fadeIn")
	Eventos.connect("detectoZonaRecarga", self, "_on_detectoZonaRecarga")
	Eventos.connect("cambioNumeroMeteorito", self, "_on_cambioNumeroMeteorito")
	Eventos.connect("actualizarTiempo", self, "_on_actualizarInfoTeempo")
	Eventos.connect("actualizarEnergiaLaser", self, "_on_actualizarEnergiaLaser")
	Eventos.connect("actualizarEnergiaEscudo", self, "_on_actualizarEnergiaEscudo")
	Eventos.connect("ocultarInfoEnergiaLaser", infoEnergiaLaser, "ocultar")
	Eventos.connect("ocultarInfoEnergiaEscudo", infoEnergiaEscudo, "ocultar")
	Eventos.connect("naveDestruida", self, "_on_naveDestruida")


func fadeIn() -> void:
	$AnimationPlayer.play("fadeIn")


func fadeOut() -> void:
	$AnimationPlayer.play_backwards("fadeIn")


func _on_detectoZonaRecarga(enZona: bool) -> void:
	if enZona:
		infoZonaRecarga.mostrarSuavizado()
	else:
		infoZonaRecarga.ocultarSuavizado()


func _on_cambioNumeroMeteorito(numero: int) -> void:
	infoMeteoritos.mostrarSuavizado()
	infoMeteoritos.modificarTexto(
		"Meteoritos restantes\n {cantidad}".format({"cantidad":numero})
	)


func _on_actualizarInfoTeempo(tiempoRestante: int) -> void:
	var minutos:int = floor(tiempoRestante * 0.01666666666667)
	var segundos:int = tiempoRestante % 60
	infoTiempoRestante.modificarTexto(
		"Tiempo Restante:\n %02d: %02d" % [minutos, segundos]
	)
	if tiempoRestante % 10 == 0:
		infoTiempoRestante.mostrarSuavizado()
	if tiempoRestante == 11:
		infoTiempoRestante.set_autoOcultar(false)
	elif tiempoRestante == 0:
		infoTiempoRestante.ocultar()


func _on_actualizarEnergiaLaser(energiaMaxima: float, energiaActual: float) -> void:
	infoEnergiaLaser.mostrar()
	infoEnergiaLaser.actualizarEnergiaMedidor(energiaMaxima, energiaActual)


func _on_actualizarEnergiaEscudo(energiaMaxima: float, energiaActual: float) -> void:
	infoEnergiaEscudo.mostrar()
	infoEnergiaEscudo.actualizarEnergiaMedidor(energiaMaxima, energiaActual)


#func _on_naveDestruida(nave:NaveBase, _posicion, _explosoines) -> void:
#	if nave is Player:
#		get_tree().call_group("contenedorInfo", "set_estaActivo", false)
#		get_tree().call_group("contenedorInfo", "ocultar") 
