class_name Escudo
extends Area2D


export var energiaEscudo:float = 8.0
export var radioDesgaste:float = -1.6

var energiaEscudoOriginal:float
var estaActivado:bool = false setget ,getEstaActivado

onready var colisionador: CollisionShape2D = $CollisionShape2D
onready var animacion: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	set_process(false)
	colisionador.set_deferred("disabled", true)
	energiaEscudoOriginal = energiaEscudo 


func _process(delta: float) -> void:
	controlarEnergiaEscudo(radioDesgaste * delta)


func getEstaActivado() -> bool:
	return estaActivado


func activar() -> void:
	if energiaEscudo <= 0.0:
		return
	
	colisionador.set_deferred("disabled", false)
	estaActivado = true
	animacion.play("activandose")


func desactivar() -> void:
	colisionador.set_deferred("disabled", true)
	estaActivado = false
	set_process(false)
	animacion.play_backwards("activandose")


func controlarEnergiaEscudo(consumoEscudo: float) -> void:
	energiaEscudo += consumoEscudo 
	
	if energiaEscudo <= 0.0:
		desactivar()
		Eventos.emit_signal("ocultarInfoEnergiaEscudo")
		return
	elif energiaEscudo > energiaEscudoOriginal:
		energiaEscudo = energiaEscudoOriginal
	
	Eventos.emit_signal("actualizarEnergiaEscudo", energiaEscudoOriginal, energiaEscudo)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activandose" and estaActivado:
		animacion.play("activado")
		set_process((true))


func _on_Escudo_area_entered(area: Area2D) -> void:
	if area is Proyectil:
		area.queue_free()

