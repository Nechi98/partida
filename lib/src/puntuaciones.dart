import 'package:partida/partida.dart';
import 'jugador.dart';

const int ninguna = 0;
const int maximoCartasR1 = 10;

class PRonda1{
  final Jugador jugador;
  final int cartasAzules;

  PRonda1({required this.jugador, required this.cartasAzules}){
    if(cartasAzules < ninguna) throw ProblemaAzulesNegativas();
    if(cartasAzules > maximoCartasR1) throw ProblemaMuchasCartasEnTotal();
  }
}

class PRonda2{
  final Jugador jugador;
  final int cartasAzules;
  final int cartasVerdes;

  PRonda2({required this.jugador, required this.cartasAzules, required this.cartasVerdes}){
    if(cartasAzules < ninguna) throw ProblemaAzulesNegativas();
    if(cartasVerdes < ninguna) throw ProblemaVerdesNegativas();
  }
}

class PRonda3{
  final Jugador jugador;
  final int cartasAzules;
  final int cartasVerdes;
  final int cartasGrises;
  final int cartasRosas;

  PRonda3({required this.jugador, required this.cartasAzules, required this.cartasVerdes, required this.cartasGrises, required this.cartasRosas}){
    if(cartasAzules < ninguna) throw ProblemaAzulesNegativas();
    if(cartasVerdes < ninguna) throw ProblemaVerdesNegativas();
    if(cartasGrises < ninguna) throw ProblemaGrisesNegativas();
    if(cartasRosas < ninguna) throw ProblemaRosasNegativas();
  }
}