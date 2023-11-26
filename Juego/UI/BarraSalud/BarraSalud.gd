class_name BarraSalud
extends ProgressBar


export var siempreVisible:bool = false

onready var tweenVisibilidad:Tween = $TweenVisibilidad


func _ready() -> void:
	modulate = Color(1, 1, 1, siempreVisible)


func set_hitpointsActual(hitpoints: float) -> void:
	value = hitpoints


func controlarBarra(hitpointsNave: float, mostrar: bool) -> void:
	value = hitpointsNave
	
	if not tweenVisibilidad.is_active() and modulate.a != int(mostrar):
		tweenVisibilidad.interpolate_property(
			self,
			"modulate",
			Color(1, 1, 1, not mostrar),
			Color(1, 1, 1, mostrar),
			1.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		tweenVisibilidad.start()


func set_valores(hitpoints: float) -> void:
	max_value = hitpoints
	value = hitpoints
	


func _on_TweenVisibilidad_tween_all_completed() -> void:
	if modulate.a == 1.0:
		controlarBarra(value, false)
