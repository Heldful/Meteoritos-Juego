class_name BaseEnemiga
extends Node2D


export var baseEnemigaHitpoints:float = 30
var estaDestruida:bool = false

onready var impactoSFX:AudioStreamPlayer2D = $ImpactoSFX
#func _ready() -> void:
#	$AnimationPlayer.play(elegirAnimacionAleatoria())


func _process(delta: float) -> void:
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play(elegirAnimacionAleatoria())


func recibirDanio(danio: float) -> void:
	baseEnemigaHitpoints -= danio
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
	Eventos.emit_signal("baseDestruida", posicionesPartes)
	queue_free()



func elegirAnimacionAleatoria() -> String:
	randomize()
	var numeroAnimaciones:int = $AnimationPlayer.get_animation_list().size() - 1
	var indiceAnimacionAleatoria:int = randi() % numeroAnimaciones + 1
	var listaAnimaciones:Array = $AnimationPlayer.get_animation_list()
	print(listaAnimaciones[indiceAnimacionAleatoria])
	return listaAnimaciones[indiceAnimacionAleatoria] 


func _on_AreaColisionFisica_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
