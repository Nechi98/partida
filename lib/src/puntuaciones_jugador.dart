import 'package:partida/partida.dart';

class P {}

class PJugador extends P {}

class PJugadorFinal extends P {}

class PuntuacionJugador{
  final Jugador jugador;
  final int porAzules;
  final int porVerdes;
  final int porGrises;
  final int porRosas;

  int get total => porAzules + porGrises + porVerdes + porRosas;

  PuntuacionJugador({required this.jugador, required this.porAzules,required this.porVerdes,required this.porGrises,required this.porRosas});

}