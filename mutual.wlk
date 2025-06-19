class Actividad {
  const idiomas = []
  method implicaEsfuerzo()
  method sirveBroncearse()
  method cantDias()
  method esInteresante() = idiomas.size() > 1
  method esRecomendadaPara(unSocio) = self.esInteresante() and unSocio.leAtrae(self) and unSocio.realizo(self)
}

class ViajePlaya inherits Actividad {
  const largo
  override method cantDias() = largo / 500
  override method implicaEsfuerzo() = largo > 1200
  override method sirveBroncearse() = true
}
class ExcursionCiudad inherits Actividad {
  const cantAtracciones
  override method cantDias() = cantAtracciones / 2
  override method implicaEsfuerzo() = cantAtracciones.between(5, 8)
  override method sirveBroncearse() = false
  override method esInteresante() = super() || cantAtracciones == 5
}
class ExcursionCiudadTropical inherits ExcursionCiudad {
  override method cantDias() = super() + 1
  override method sirveBroncearse() = true
}
class Trekking inherits Actividad {
  const kmSenderos
  const diasSol
  override method cantDias() = kmSenderos / 50
  override method implicaEsfuerzo() = kmSenderos > 80
  override method sirveBroncearse() = diasSol > 200 || diasSol.between(100, 200) and kmSenderos > 120
  override method esInteresante() = super() and diasSol > 140
}
class ClasesGimnasia inherits Actividad{
  method initialize(){
    idiomas.clear()
    idiomas.add("español")
  }
  override method cantDias() = 1
  override method implicaEsfuerzo() = true
  override method sirveBroncearse() = false
  override method esRecomendadaPara(unSocio) = unSocio.edad().between(20, 30)
}
class TallerLiterario inherits Actividad {
  const libros = []
  method idiomasUsados() = libros.map({l=> l.idioma()})
  method cantLibros() = libros.size()
  method hayLibroConMasDe500Pags() = libros.any({l=>l.paginas() > 500})
  method todosLosLibrosMismoAutor() = libros.map({ l => l.nombreAutor() }).asSet().size() == 1
  override method cantDias() = self.cantLibros() + 1
  override method implicaEsfuerzo() = self.hayLibroConMasDe500Pags() || (self.todosLosLibrosMismoAutor() and self.cantLibros() > 1)
  override method sirveBroncearse() = false
  override method esRecomendadaPara(unSocio) = unSocio.idiomas().size() > 1
}
class Libro {
  const property idioma
  const property cantPaginas
  const property autor
}
class Socio {
  const actividades = []
  const idiomas = []
  const cantMaximaActividades
  var property edad
  method cantIdiomasSocio() = idiomas.size()
  method registrarActividad(unaActividad) {
    if(actividades.size() < cantMaximaActividades) {
      actividades.add(unaActividad)
    }
    else {
      self.error("Alcanzaste la maxima cantidad de actividades por hacer")
    }
  }
  method esAdoradorDelSol() = actividades.all({a => a.sirveBroncearse()})
  method actividadesEsforzadas() = actividades.filter({a => a.implicaEsfuerzo()})
  method leAtrae(unaActividad)
  method realizo(unaActividad) = actividades.contains(unaActividad)
}

class Tranquilo inherits Socio {
  override method leAtrae(unaActividad) = unaActividad.cantDias() >= 4
}
class Coherente inherits Socio {
  override method leAtrae(unaActividad) = 
  if(self.esAdoradorDelSol()){
    unaActividad.sirveBroncearse()
  }
  else {
    unaActividad.implicaEsfuerzo()
  }
}

class Relajado inherits Socio {
  override method leAtrae(unaActividad) = not idiomas.intersection(unaActividad.idiomas()).isEmpty()
}

