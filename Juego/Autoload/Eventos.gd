extends Node


signal nivelIniciado()
signal nivelTerminado()

signal disparo(proyectil)
signal naveDestruida(nave, posicion, explosiones)
signal baseDestruida(base, posiciones)
signal naveEnSectorDePeligro(centroCamara, tipoPeligro, numPeligros)
signal detectoZonaRecarga(entrando)

signal spawnMeteorito(posicion, direccion, tamanio)
signal spawnEnemigoOrbital(orbital)
signal explosionMeteorito(posicion)

signal cambioNumeroMeteorito(numero)
signal actualizarTiempo(tiempoRestante)
signal actualizarEnergiaLaser(energiaMaxima, energiaActual)
signal ocultarInfoEnergiaLaser()
signal actualizarEnergiaEscudo(energiaMaxima, energiaActual)
signal ocultarInfoEnergiaEscudo()

signal minimapaObjetoCreado()
signal minimapaObjetoDestruido(objeto)
