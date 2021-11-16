import 'package:partida/src/jugador.dart';
import 'package:partida/src/problemas.dart';
import 'package:test/test.dart';

void main() {
  group('Jugador', (){
    test('Debe de tener nombre no vacio', (){
      expect(() => Jugador(nombre: ''),
      throwsA(TypeMatcher<ProblemaNombreJugadorVacio>()));
    });
    test('Mismo nombre, mismo id', (){
      Jugador j1 = Jugador(nombre: 'Ramiro');
      Jugador j2 = Jugador(nombre: 'Ramiro');
      expect(j1, equals(j2));
    });
    test('Diferente nombre, diferente id', (){
      Jugador j1 = Jugador(nombre: 'Ramiro');
      Jugador j2 = Jugador(nombre: 'Jose');
      expect(j1, isNot(equals(j2)));
    });
  });
}