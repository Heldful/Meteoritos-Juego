extends Node


var playerActual:Player = null setget setPlayerActual, getPlayerActual


func _ready() -> void:
	Eventos.connect("naveDestruida", self, "_on_naveDestruida")


func setPlayerActual(player: Player) -> void:
	playerActual = player


func getPlayerActual() -> Player:
	return playerActual


func _on_naveDestruida(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave == playerActual:
		playerActual = null
