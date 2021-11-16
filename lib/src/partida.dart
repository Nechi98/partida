import 'dart:collection';
import 'package:partida/partida.dart';
import 'helpers.dart';
import 'jugador.dart';
import 'puntuaciones.dart';
import 'puntuaciones_jugador.dart';

const numMaxJugadores = 4;
const numMinJugadores = 2;
const maxCartasR2 = 20;
const maxCartasR3 = 30;
const puntosPorAzul = 3;
const puntosPorVerde = 4;
const puntosPorNegra = 7;
const puntosPorRosa = [
  0,
  1,
  3,
  6,
  10,
  15,
  21,
  28,
  36,
  45,
  55,
  66,
  78,
  91,
  105,
  120
];
enum FasePuntuacion { ronda1, ronda2, ronda3, desenlace }

class Partida {
  final Set<Jugador> jugadores;

  Partida({required this.jugadores}) {
    if (jugadores.length < numMinJugadores)
      throw ProblemaNumeroJugadoresMenorMinimo();
    if (jugadores.length > numMaxJugadores)
      throw ProblemaNumeroJugadoresMayorMaximo();
  }

  List<PRonda1> _puntuacionesRonda1 = [];
  List<PRonda2> _puntuacionesRonda2 = [];
  List<PRonda3> _puntuacionesRonda3 = [];

  List<PuntuacionJugador> puntuaciones(FasePuntuacion ronda) {
    List<PuntuacionJugador> _puntuacionesJugador = [];
    switch (ronda) {
      case FasePuntuacion.ronda1:
        for (var pRonda1 in _puntuacionesRonda1) {
          Jugador jugador = pRonda1.jugador;
          int azules = pRonda1.cartasAzules;
          _puntuacionesJugador.add(PuntuacionJugador(
              jugador: jugador,
              porAzules: puntosPorAzul * azules,
              porVerdes: 0,
              porRosas: 0,
              porGrises: 0));
        }
        return _puntuacionesJugador;
      case FasePuntuacion.ronda2:
        for (var pRonda2 in _puntuacionesRonda2) {
          _puntuacionesJugador.add(PuntuacionJugador(
              jugador: pRonda2.jugador,
              porAzules: pRonda2.cartasAzules * puntosPorAzul,
              porVerdes: pRonda2.cartasVerdes * puntosPorVerde,
              porRosas: 0,
              porGrises: 0));
        }
        return _puntuacionesJugador;
      case FasePuntuacion.ronda3:
        for (var pRonda3 in _puntuacionesRonda3) {
          _puntuacionesJugador.add(PuntuacionJugador(
              jugador: pRonda3.jugador,
              porAzules: pRonda3.cartasAzules * puntosPorAzul,
              porVerdes: pRonda3.cartasVerdes * puntosPorVerde,
              porGrises: pRonda3.cartasGrises * puntosPorNegra,
              porRosas: pRonda3.cartasRosas > 15 ? 120: puntosPorRosa[pRonda3.cartasRosas]));
        }
        return _puntuacionesJugador;
      case FasePuntuacion.desenlace:
        // list<pjugador> r1 = puntuaciones(fase1);
        // list<pjugador> r1 = puntuaciones(fase1);
        // list<pjugador> r1 = puntuaciones(fase1);
        // r1+r2+r3

        for (Jugador j in jugadores) {
          int total = puntuaciones(FasePuntuacion.ronda1)
                  .firstWhere((element) => element.jugador == j)
                  .total +
              puntuaciones(FasePuntuacion.ronda2)
                  .firstWhere((element) => element.jugador == j)
                  .total +
              puntuaciones(FasePuntuacion.ronda3)
                  .firstWhere((element) => element.jugador == j)
                  .total;
          //PuntuacionJugador p = PuntuacionJugador(jugador: j, porAzules: porAzules, porVerdes: porVerdes, porRosas: porRosas, porGrises: porGrises)
        }

        return [];
    }
  }

  void puntuacionRonda1(List<PRonda1> puntuaciones) {
    Set<Jugador> jugadoresR1 = puntuaciones.map((e) => e.jugador).toSet();
    if (!setEquals(jugadores, jugadoresR1))
      throw ProblemaJugadoresDiscordantes();

    _puntuacionesRonda1 = puntuaciones;
  }

  void puntuacionRonda2(List<PRonda2> puntuaciones) {
    if (_puntuacionesRonda1.isEmpty) throw ProblemaOrdenIncorrecto();

    if (!setEquals(jugadores, puntuaciones.map((e) => e.jugador).toSet()))
      throw ProblemaJugadoresDiscordantes();

    for (PRonda2 segundaPuntuacion in puntuaciones) {
      PRonda1 primeraPuntuacion = _puntuacionesRonda1.firstWhere(
          (element) => element.jugador == segundaPuntuacion.jugador);
      if (primeraPuntuacion.cartasAzules > segundaPuntuacion.cartasAzules)
        throw ProblemaAzulesMenosQueAntes();
    }

    for (PRonda2 p in puntuaciones) {
      if (p.cartasAzules > maxCartasR2) throw ProblemaAzulesMuchas();
      if (p.cartasVerdes > maxCartasR2) throw ProblemaVerdesMuchas();
      if ((p.cartasAzules + p.cartasVerdes) > maxCartasR2)
        throw ProblemaMuchasCartasEnTotal();
    }

    _puntuacionesRonda2 = puntuaciones;
  }

  void puntuacionRonda3(List<PRonda3> puntuaciones) {
    if (_puntuacionesRonda2.isEmpty) throw ProblemaOrdenIncorrecto();

    if (!setEquals(jugadores, puntuaciones.map((e) => e.jugador).toSet()))
      throw ProblemaJugadoresDiscordantes();

    for (PRonda3 terceraPuntuacion in puntuaciones) {
      PRonda2 segundaPuntuacion = _puntuacionesRonda2.firstWhere(
          (element) => element.jugador == terceraPuntuacion.jugador);
      if (segundaPuntuacion.cartasAzules > terceraPuntuacion.cartasAzules)
        throw ProblemaAzulesMenosQueAntes();
      if (segundaPuntuacion.cartasVerdes > terceraPuntuacion.cartasVerdes)
        throw ProblemaVerdesMenosQueAntes();
    }

    for (PRonda3 p in puntuaciones) {
      if (p.cartasAzules > maxCartasR3) throw ProblemaAzulesMuchas();
      if (p.cartasVerdes > maxCartasR3) throw ProblemaVerdesMuchas();
      if (p.cartasGrises > maxCartasR3) throw ProblemaGrisesMuchas();
      if (p.cartasRosas > maxCartasR3) throw ProblemaRosasMuchas();
      if ((p.cartasAzules + p.cartasVerdes + p.cartasGrises + p.cartasRosas) >
          maxCartasR3) throw ProblemaMuchasCartasEnTotal();
    }

    _puntuacionesRonda3 = puntuaciones;
  }
}
