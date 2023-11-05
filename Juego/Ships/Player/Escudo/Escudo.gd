class_name Escudo
extends Area2D


export var energia:float = 8.0
export var radioDesgaste:float = -1.6

var estaActivado:bool = false setget ,getEstaActivado

onready var colisionador: CollisionShape2D = $CollisionShape2D
onready var animacion: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	set_process(false)
	colisionador.set_deferred("disabled", true)

func _process(delta: float) -> void:
	energia += radioDesgaste * delta
	if energia <= 0.0:
		desactivar()

func getEstaActivado() -> bool:
	return estaActivado

func activar() -> void:
	if energia <= 0.0:
		return
	
	colisionador.set_deferred("disabled", false)
	estaActivado = true
	animacion.play("activandose")


func desactivar() -> void:
	colisionador.set_deferred("disabled", true)
	estaActivado = false
	set_process(false)
	animacion.play_backwards("activandose")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activandose" and estaActivado:
		animacion.play("activado")
		set_process((true))
