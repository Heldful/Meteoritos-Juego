class_name ContenedorInformacionEnergia
extends ContenedorInformacion


onready var medidor:ProgressBar = $ProgressBar


func actualizarEnergiaMedidor(energiaMaxima: float, energiaActual: float) -> void:
	var energiaPorcentual:int = (energiaActual * 100) / energiaMaxima
	medidor.value = energiaPorcentual
