class_name LaserBeam
extends RayCast2D


export var cast_speed := 7000.0
export var max_length := 1400.0
export var growth_time := 0.1
export var radioDanio:float = 15
export var energiaBeam:float = 9999
export var radioEnergiaBeamDesgaste = -1 
var is_casting := false setget set_is_casting
var energiaBeamOriginal:float 

onready var fill := $FillLine2D
onready var tween := $Tween
onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var beam_particles := $BeamParticles2D
onready var laserBeamSFX:AudioStreamPlayer2D = $LaserBeamSFX
onready var line_width: float = fill.width


func _ready() -> void:
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO
	energiaBeamOriginal = energiaBeam


func _physics_process(delta: float) -> void:
	if is_casting:
		cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
		cast_beam(delta)


func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		laserBeamSFX.play()
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
	else:
		Eventos.emit_signal("ocultarInfoEnergiaLaser")
		laserBeamSFX.stop()
		# Reset the laser endpoint
		fill.points[1] = Vector2.ZERO
		
		collision_particles.emitting = false
		disappear()

	set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting


func cast_beam(delta: float) -> void:
	if energiaBeam <= 0:
		set_is_casting(false)
	
	controlarEnergiaBeam(radioEnergiaBeamDesgaste * delta)
	
	var cast_point := cast_to

	force_raycast_update()
	collision_particles.emitting = is_colliding()

	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		if get_collider().has_method("recibirDanio"):
			var magnitudDanio = radioDanio * delta
			get_collider().recibirDanio(magnitudDanio)

	fill.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5


func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()



func disappear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()


func controlarEnergiaBeam(consumoBeam: float) -> void:
	energiaBeam += consumoBeam
	if energiaBeam > energiaBeamOriginal:
		energiaBeam = energiaBeamOriginal
	Eventos.emit_signal("actualizarEnergiaLaser", energiaBeamOriginal, energiaBeam)
