class_name EnemigoInterceptor
extends EnemigoBase


enum EstadoAI {IDDLE, ATACANDOQ, ATACANDOP, PERSECUCION}

export var potenciaMaximaEnemigo:float = 800.0
var estadoAIActual: int = EstadoAI.IDDLE
var potenciaEnemigoActual:float = 0.0


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += playerDireccion.normalized() * potenciaEnemigoActual * state.get_step()
	
	linear_velocity.x = clamp(linear_velocity.x, -potenciaMaximaEnemigo, potenciaEnemigoActual)
	linear_velocity.y= clamp(linear_velocity.y, -potenciaMaximaEnemigo, potenciaEnemigoActual)


func controladorEstadosAI(nuevoEstado: int) -> void:
	match nuevoEstado:
		EstadoAI.IDDLE:
			canion.setEstaDisparando(false)
			potenciaEnemigoActual = 0.0
		EstadoAI.ATACANDOQ:
			canion.setEstaDisparando(true)
			potenciaEnemigoActual = 0.0
		EstadoAI.ATACANDOP:
			canion.setEstaDisparando(true)
			potenciaEnemigoActual = potenciaMaximaEnemigo
		EstadoAI.PERSECUCION:
			canion.setEstaDisparando(false)
			potenciaEnemigoActual = potenciaMaximaEnemigo
		_:
			printerr("Error")
	
	estadoAIActual = nuevoEstado


func _on_AreaDeteccion_body_entered(body: Node) -> void:
	controladorEstadosAI(EstadoAI.ATACANDOQ)


func _on_AreaDeteccion_body_exited(body: Node) -> void:
	controladorEstadosAI(EstadoAI.ATACANDOP)


func _on_AreaDisparo_body_entered(body: Node) -> void:
	controladorEstadosAI(EstadoAI.ATACANDOP)


func _on_AreaDisparo_body_exited(body: Node) -> void:
	controladorEstadosAI(EstadoAI.PERSECUCION)
