class_name Nivel
extends Node


export var explosion:PackedScene = null

onready var contenedorProyectiles:Node


func _ready() -> void:
	conectarSeniales()
	crearContenedores()


func conectarSeniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")
	Eventos.connect("naveDestruida", self, "_on_naveDestruida")


func crearContenedores() -> void:
	contenedorProyectiles = Node.new()
	contenedorProyectiles.name = "ContenedorProyectiles"
	add_child(contenedorProyectiles)


func _on_disparo(proyectil:Proyectil) -> void:
	contenedorProyectiles.add_child(proyectil)


func _on_naveDestruida(posicion: Vector2, numExplosiones: int) -> void:
	for i in range(numExplosiones):
		var newExplosion:Node2D = explosion.instance()
		newExplosion.global_position = posicion
		add_child(newExplosion)
		yield(get_tree().create_timer(0.6), "timeout")
