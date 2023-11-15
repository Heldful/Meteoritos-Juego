class_name ExplosionMeteorito
extends Node2D



func _ready() -> void:
	$AnimationPlayer.play(explosionAleatoria())


func explosionAleatoria() -> String:
	randomize()
	var numeroAnimacion:int = $AnimationPlayer.get_animation_list().size() - 1
	var indiceAnimacioAleatoria:int = randi() % (numeroAnimacion + 1)
	var listaAnimacion:Array = $AnimationPlayer.get_animation_list()
	
	return listaAnimacion[indiceAnimacioAleatoria]

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
