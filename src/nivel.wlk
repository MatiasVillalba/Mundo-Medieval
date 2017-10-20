import wollok.game.*

object personaje {
	/*const posicion = game.at(10,6)*/
	const posicion = game.at(2,4)
	var imagen = "armadura.png"
	var elementosEquipados = []
	var fuerza = 10
	var defensa = 10
	var vida = 100
	var diamantes = []
	
	method equipar(algo) {
		if(self.elementosPersonaje().contains(algo)) {
			error.throwWithMessage("El personaje ya tiene el elemento equipado")
			}
			algo.equiparse(self)
	}
	
	method recibirAtaque(danioCriatura) {
		if(self.vida() <= danioCriatura) {
			self.restarVida(self.vida())
			game.removeVisual(self)
			game.removeVisual(diamanteVerde)
			game.removeVisual(diamanteAzul)
			game.removeVisual(bestia)
			game.removeVisual(casa)
			game.removeVisual(hechicero)
			game.removeVisual(cofre)
			mapa.cambiarImagen("calavera.png")
		}
		else {
			self.restarVida((danioCriatura - self.defensaPersonaje()).max(0))
		}
	}
	
	method canjearDiamantes() {
		if(self.diamantes().contains(diamanteAzul)) {
			self.diamantes().remove(diamanteAzul)
			self.equipar(daga)
		}
		if(self.diamantes().contains(diamanteVerde)) {
			self.diamantes().remove(diamanteVerde)
			self.equipar(casco)
		}
		if(self.elementosPersonaje().contains(superEspada)) {
			self.elementosPersonaje().remove(superEspada)
		}
		if(self.elementosPersonaje().contains(superCasco)) {
			self.elementosPersonaje().remove(superCasco)
		}
		if(self.elementosPersonaje().contains(superArmadura)) {
			self.elementosPersonaje().remove(superArmadura)
		}
		
	}
	
	method adquirirElemento(elem){
		elem.modificarPersonaje(self)
	}
	
	method restarVida(cantidad) {
		vida-=cantidad
	}
	
	method aumentarVida(cantidad){
		vida+=cantidad
	}
	
	method vida() = vida
	
	method fuerzaPersonaje() {
		return fuerza
	}
	
	method defensaPersonaje() {
		return defensa
	}
	
	method restarDefensa(unaCantidad) {
		defensa = self.defensaPersonaje() - unaCantidad
	}
	
	method restarFuerza(unaCantidad) {
		fuerza = self.fuerzaPersonaje() - unaCantidad
	}
	
	method aumentarDefensa(unaCantidad) {
		defensa = self.defensaPersonaje() + unaCantidad
	}
	
	method aumentarFuerza(unaCantidad) {
		fuerza = self.fuerzaPersonaje() + unaCantidad
	}
	
	method elementosPersonaje(elemento) {
		elementosEquipados.add(elemento)
	}
	
	method elementosPersonaje() {
		return elementosEquipados
	}
	
	method agregarUnDiamante(diamt){
		diamantes.add(diamt)
	}
	
	method diamantes() = diamantes
 	
	method imagen() {
		return imagen
	}
	
	method modificarImagen(unaImagen) {
		imagen = unaImagen
	}
	
	method danioPersonaje() {
		return self.elementosPersonaje().sum({e => e.fuerza()})
	}
	
	method atacarA(unaCriatura) {
		unaCriatura.recibirAtaque(self.danioPersonaje())
	}
	
	method configuracion() {
	//	CONFIGURACIÓN DEL JUEGO
		game.title("Mundo Medieval")
		game.height(12)
		game.width(20)
		DOWN.onPressDo{ posicion.moveDown(1) }
	    UP.onPressDo{ posicion.moveUp(1) }
	    RIGHT.onPressDo{ posicion.moveRight(1) }
	    LEFT.onPressDo{ posicion.moveLeft(1) }	
	    
	    /* metodo para interactuar con objetos */
	   SPACE.onPressDo { 
		const colliders = game.colliders(self)
		if (colliders.isEmpty()) 
			throw new Exception("Seguire caminando")
		colliders.head().interactua(self)
	}

		C.onPressDo { 
		const colliders = game.colliders(self)
		if (colliders.isEmpty()) 
			throw new Exception("Seguire caminando")
		colliders.head().interactuaCasa(self)
	}
		
		CONTROL.onPressDo {
		const colliders = game.colliders(self)
		if (colliders.isEmpty()) 
			throw new Exception("Seguire caminando")
		if(colliders.head().esBestia()) {
			colliders.head().interactuaBestia(self)		
		}
		if(colliders.head().esBestia().negate()) {
			colliders.head().interactuaHechicero(self)
		}
		if(hechicero.vidaHechicero() <= 0 && bestia.vidaBestia() <= 0) {
			game.say(self,"Eh salvado a este mundo de la maldad!")	
		}
		}
		
		A.onPressDo {
		const colliders = game.colliders(self)
		if (colliders.isEmpty()) 
			throw new Exception("Seguire caminando")
		colliders.head().interactuaCofre(self)	
		}
				
}
}

object mapa {
		var imagen = "mapa.png"
		
		var posicion = game.at(0,0)
	 	
	 	method posicion(unaPosicion) {
	 		posicion = unaPosicion
	 		unaPosicion.clear()
	 	}
		
		method cambiarImagen(unaImagen) {
			imagen = unaImagen
		}
		
		method imagen() {
			return imagen
		}
		
		method cargarMapa() {
			new Position(0,0).drawElement(self)
	 		new Position(5,6).drawElement(bestia)
	 		new Position(13,5).drawElement(diamanteAzul)
	 		new Position(16,4).drawElement(diamanteVerde)
	 		new Position(1,6).drawElement(casa)
	 		new Position(11,6).drawElement(hechicero)
	 		new Position(18,6).drawElement(cofre)
	 		game.addVisual(personaje)
		}
		
}

object casa {
	var imagen = "casa.png"
	
	method imagen() {
		return imagen
	}
	
	method interactuaCasa(personaje) { personaje.canjearDiamantes() }
}

object diamanteAzul{
	var imagen="diamanteP.png"
	var posicion
	
	method posicion(unaPosicion) {
	 		posicion = unaPosicion
	 		unaPosicion.clear()
	 	}
	 
	method vidaQueAumenta() {
		return 10
	}
	 	
	method modificarPersonaje(unPersonaje){ 
		if((unPersonaje.vida() + self.vidaQueAumenta()) > 100) {
			unPersonaje.aumentarVida(100 - unPersonaje.vida())	
			}
			else {
				unPersonaje.aumentarVida(self.vidaQueAumenta())
			}
			unPersonaje.agregarUnDiamante(self)	
			game.removeVisual(self)
		
	}
	
	method imagen() = imagen
	
	method interactua(personaje) { personaje.adquirirElemento(self) }
}


object diamanteVerde{
	var imagen="verde.png"
	var posicion
	method posicion(unaPosicion) {
	 		posicion = unaPosicion
	 		unaPosicion.clear()
	 	}
	
	method vidaQueAumenta() {
		return 5
	}
	 	
	method modificarPersonaje(unPersonaje){ 
		if((unPersonaje.vida() + self.vidaQueAumenta()) > 100) {
			unPersonaje.aumentarVida(100 - unPersonaje.vida())	
			}
			else {
				unPersonaje.aumentarVida(self.vidaQueAumenta())
			}
			unPersonaje.agregarUnDiamante(self)	
			game.removeVisual(self)
		
	}
	
	method imagen() = imagen
	
	method interactua(personaje) { personaje.adquirirElemento(self) }
}

object hechicero {
		var imagen = "hechicero.png"
		var vida = 200
		
		method imagen() {
			return imagen
		}
		
		method danio() {
			return 60
		}
		
		method esBestia() {
			return false
		}
		
		method vidaHechicero() {
			return vida
		}
		
		method restarVidaHechicero(danioPersonaje) {
	 		vida = self.vidaHechicero() - danioPersonaje
	 	}
		
		method recibirAtaque(danioPersonaje) {
			if(self.vidaHechicero() > danioPersonaje) {
	 			self.restarVidaHechicero(danioPersonaje)	
	 		}
	 		else {
	 			self.restarVidaHechicero(self.vidaHechicero())
	 			game.removeVisual(self)
	 		}
	 		personaje.recibirAtaque(self.danio())
		}
		
		method interactuaHechicero(personaje) { personaje.atacarA(self) }
		
}

object bestia {
		var imagen = "bestia.png"
	 	var vida = 100
	 	
	 	method imagen() {
	 		return imagen
	 	}
	 	
	 	method danio() {
	 		return 40
	 	}
	 	
	 	method esBestia() {
	 		return true
	 	}
	 	
	 	method vidaBestia() {
	 		return vida
	 	}
	 	
	 	method restarVidaBestia(danioPersonaje) {
	 		vida = self.vidaBestia() - danioPersonaje
	 	}
	 	
	 	method recibirAtaque(danioPersonaje) {
	 		if(self.vidaBestia() > danioPersonaje) {
	 			self.restarVidaBestia(danioPersonaje)
	 			}	
	 			else {
	 				self.restarVidaBestia(self.vidaBestia())
	 				game.removeVisual(self)
	 				}
	 				personaje.recibirAtaque(self.danio())
	 	}
	 	
	 	method interactuaBestia(personaje) { personaje.atacarA(self) }
	 	
	 	
}

object cofre {
	var imagen = "cofre.png"
	
	method interactuaCofre(personaje) { 
		personaje.elementosPersonaje().clear()
		personaje.equipar(superCasco)
		personaje.equipar(superEspada)
		personaje.equipar(superArmadura)
		game.removeVisual(self)
		personaje.modificarImagen("superGuerrero.png")
	}
}

object superArmadura {
	
	method defensa() {
		return 35	
	}
	
	method fuerza() {
		return 20
	}
	
	method equiparse(unPersonaje) {
		unPersonaje.elementosPersonaje(self)
		unPersonaje.aumentarDefensa(self.defensa())
		unPersonaje.aumentarFuerza(self.fuerza())
	}
	
}

object superEspada {
	
	method defensa() {
		return 20
	}
	
	method fuerza() {
		return 45
	}
	
	method equiparse(unPersonaje) {
		unPersonaje.elementosPersonaje(self)
		unPersonaje.aumentarDefensa(self.defensa())
		unPersonaje.aumentarFuerza(self.fuerza())
	}
	
}

object superCasco {
	
	method defensa() {
		return 30
	}
	
	method fuerza() {
		return 25
	}
	
	method equiparse(unPersonaje) {
		unPersonaje.elementosPersonaje(self)
		unPersonaje.aumentarDefensa(self.defensa())
		unPersonaje.aumentarFuerza(self.fuerza())
	}
	
	
}

object daga {
	
	method defensa() {
		 return 15
	}
	
	method fuerza() {
		return 35
	}
	
	method equiparse(unPersonaje) {
		if(unPersonaje.elementosPersonaje().contains(casco)) {
			unPersonaje.modificarImagen("guerrero.png")
		}
		else {
			unPersonaje.modificarImagen("daga.png")	
		}
		
		unPersonaje.elementosPersonaje(self)
		unPersonaje.aumentarDefensa(self.defensa())
		unPersonaje.aumentarFuerza(self.fuerza())
	}
}

object casco {
	
	method fuerza() {
		return 15
	}
	
	method defensa() {
		return 20
	}
	
	method equiparse(unPersonaje) {
		if(unPersonaje.elementosPersonaje().contains(daga)) {
			unPersonaje.modificarImagen("guerrero.png")
		}
		else {
			unPersonaje.modificarImagen("casco.png")
		}
		
		unPersonaje.elementosPersonaje(self)
		unPersonaje.aumentarDefensa(self.defensa())
		unPersonaje.aumentarFuerza(self.fuerza())
	}
}




