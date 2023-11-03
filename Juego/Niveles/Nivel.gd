class_name Nivel
extends Node


onready var contenedorProyectiles:Node


func _ready() -> void:
	conectarSeniales()
	crearContenedores()


func conectarSeniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")


func crearContenedores() -> void:
	contenedorProyectiles = Node.new()
	contenedorProyectiles.name = "ContenedorProyectiles"
	add_child(contenedorProyectiles)


func _on_disparo(proyectil:Proyectil) -> void:
	contenedorProyectiles.add_child(proyectil)
