class_name SectorMeteoritos
extends Node2D


export var cantidadMeteoritos:int = 10
export var intervaloSpawn:float = 1.5

var spawners:Array


func _ready() -> void:
	$SpawnTimer.wait_time = intervaloSpawn
	almacenarSpawners()
	conectarSenialesDetectores()


func crear(pos: Vector2, meteoritos: int) -> void:
	global_position = pos
	cantidadMeteoritos = meteoritos


func almacenarSpawners() -> void:
	for spawner in $Spawners.get_children():
		spawners.append(spawner)


func spawnAleatorio() -> int:
	randomize()
	return randi() % spawners.size()


func conectarSenialesDetectores() -> void:
	for detector in $DetectorFueraZona.get_children():
		detector.connect("body_entered", self, "on_detector_body_entered")


func on_detector_body_entered(body: Node) -> void:
	if body != Player:
		return
	body.setEstaEnSector(false)


func _on_Timer_timeout() -> void:
	if cantidadMeteoritos == 0:
		$SpawnTimer.stop()
		return
	
	spawners[spawnAleatorio()].spawnearMeteorito()
	cantidadMeteoritos -= 1
