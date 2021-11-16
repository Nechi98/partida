import 'package:partida/src/jugador.dart';
import 'package:partida/src/problemas.dart';
import 'package:partida/src/puntuaciones.dart';
import 'package:test/test.dart';

void main() {
  group('Puntuacion Ronda 1', (){
    late Jugador jugador;
    setUp((){
      jugador = Jugador(nombre: 'Andres');
    });
    test('La cantidad de azules debe ser 0 o mayor', (){
      expect(() => PRonda1(jugador: jugador, cartasAzules: -1),
      throwsA(TypeMatcher<ProblemaAzulesNegativas>()));
    });
    test('La cantidad de azules debe ser 10 o menor', (){
      expect(() => PRonda1(jugador: jugador, cartasAzules: 11),
      throwsA(TypeMatcher<ProblemaMuchasCartasEnTotal>()));
    });
    test('Entre 1 y 10 ta bien', (){
      expect(() => PRonda1(jugador: jugador, cartasAzules: 6),
      returnsNormally);
    });
  });
  group('Puntuacion Ronda 2', (){
    late Jugador jugador;
    setUp((){
      jugador = Jugador(nombre: 'Andres');
    });
    test('Azules no deben ser negativas', (){
      expect(() => PRonda2(jugador: jugador, cartasAzules: -1, cartasVerdes: 4),
      throwsA(TypeMatcher<ProblemaAzulesNegativas>()));
    });
    test('Azules positivos', (){
      expect(() => PRonda2(jugador: jugador, cartasAzules: 5, cartasVerdes: 4),
      returnsNormally);
    });
    test('Verdes no pueden ser negativas', (){
      expect(() => PRonda2(jugador: jugador, cartasAzules: 6, cartasVerdes: -1),
      throwsA(TypeMatcher<ProblemaVerdesNegativas>()));
    });
    test('Verdes positivos', (){
      expect(() => PRonda2(jugador: jugador, cartasAzules: 5, cartasVerdes: 4),
      returnsNormally);
    });
  });
  group('Puntuacion Ronda 3', (){
    late Jugador jugador;
    setUp((){
      jugador = Jugador(nombre: 'Andres');
    });
    test('Azules no deben ser negativas', (){
      expect(() => PRonda2(jugador: jugador, cartasAzules: -1, cartasVerdes: 4),
      throwsA(TypeMatcher<ProblemaAzulesNegativas>()));
    });
    test('Azules positivos', (){
      expect(() => PRonda2(jugador: jugador, cartasAzules: 5, cartasVerdes: 4),
      returnsNormally);
    });
    test('Verdes no pueden ser negativas', (){
      expect(() => PRonda2(jugador: jugador, cartasAzules: 6, cartasVerdes: -1),
      throwsA(TypeMatcher<ProblemaVerdesNegativas>()));
    });
    test('Verdes positivos', (){
      expect(() => PRonda2(jugador: jugador, cartasAzules: 5, cartasVerdes: 4),
      returnsNormally);
    });
    test('Grises no pueden ser negativos', (){
      expect(() => PRonda3(jugador: jugador, cartasAzules: 6, cartasVerdes: 7, cartasGrises: -1, cartasRosas: 1),
      throwsA(TypeMatcher<ProblemaGrisesNegativas>()));
    });
    test('Grises positivos', (){
      expect(() => PRonda3(jugador: jugador, cartasAzules: 5, cartasVerdes: 4, cartasGrises: 2, cartasRosas: 1),
      returnsNormally);
    });
    test('Rosas no pueden ser negativas', (){
      expect(() => PRonda3(jugador: jugador, cartasAzules: 6, cartasVerdes: 5, cartasGrises: 1, cartasRosas: -2),
      throwsA(TypeMatcher<ProblemaRosasNegativas>()));
    });
    test('Rosas positivas', (){
      expect(() => PRonda3(jugador: jugador, cartasAzules: 5, cartasVerdes: 4, cartasGrises: 2, cartasRosas: 1),
      returnsNormally);
    });
  });

}