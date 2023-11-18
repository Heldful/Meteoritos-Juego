extends Node


var playerActual:Player = null setget setPlayerActual


func setPlayerActual(player: Player) -> void:
	playerActual = player


func getPlayerActual() -> Player:
	return playerActual
