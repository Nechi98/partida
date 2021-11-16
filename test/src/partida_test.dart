import 'package:partida/partida.dart';
import 'package:partida/src/problemas.dart';
import 'package:partida/src/puntuaciones.dart';
import 'package:test/test.dart';

void main() {
  group('Partidas', (){
    
    late Jugador j1, j2, j3, j4, j5, jRepetido;
    setUp((){
      j1 = Jugador(nombre:'Juan');
      j2 = Jugador(nombre:'Mario');
      j3 = Jugador(nombre:'Jose');
      j4 = Jugador(nombre:'Matias');
      j5 = Jugador(nombre:'Damian');
      jRepetido = Jugador(nombre:'Damian');
    });
    test('Debe tener al menos 2 jugadores',(){
      expect(()=>Partida(jugadores:{j1}), 
      throwsA(TypeMatcher<ProblemaNumeroJugadoresMenorMinimo>()));
    });
    test('Debe tener maximo 4 jugadores',(){
      expect(()=>Partida(jugadores:{j1, j2, j3, j4, j5}), 
      throwsA(TypeMatcher<ProblemaNumeroJugadoresMayorMaximo>()));
    });
    test('2 jugadores esta bien',(){
      expect(()=>Partida(jugadores:{j1, j2}), returnsNormally);
    });
  });
  group('Puntuacion Ronda 1', (){
    late Jugador j1, j2, j3;
    late PRonda1 p1, p2, p3;
    setUp((){
      j1 = Jugador(nombre:'Juan');
      j2 = Jugador(nombre:'Mario');
      j3 = Jugador(nombre:'Jose');

      p1 = PRonda1(jugador:j1, cartasAzules:3);
      p2 = PRonda1(jugador:j2, cartasAzules:5);
      p3 = PRonda1(jugador:j3, cartasAzules:7);
    });
    test('Jugadores no diferentes',(){
      Partida p = Partida(jugadores:{j1, j2});
      expect(()=>p.puntuacionRonda1([p1,p3]), 
      throwsA(TypeMatcher<ProblemaJugadoresDiscordantes>()));
    });
    test('Jugadores puntuando deben ser los mismos de la partida',(){
      Partida p = Partida(jugadores:{j1, j2});
      expect(()=>p.puntuacionRonda1([p1,p2]), 
      returnsNormally);
    });
  });
  group('Puntuacion Ronda 2', (){
    late Jugador j1, j2, j3;
    late PRonda2 p21, p22, p23, p21mala, p22mala, p21mala2;
    late PRonda1 p11, p12, p13, p11mala, p12mala;
    setUp((){
      j1 = Jugador(nombre:'Juan');
      j2 = Jugador(nombre:'Mario');
      j3 = Jugador(nombre:'Jose');

      p11 = PRonda1(jugador:j1, cartasAzules:0);
      p12 = PRonda1(jugador:j2, cartasAzules:0);
      p13 = PRonda1(jugador:j3, cartasAzules:7);
      p11mala = PRonda1(jugador:j1, cartasAzules:9);
      p12mala = PRonda1(jugador:j2, cartasAzules:6);

      p21 = PRonda2(jugador:j1, cartasAzules:1, cartasVerdes: 1);
      p22 = PRonda2(jugador:j2, cartasAzules:2, cartasVerdes: 2);
      p23 = PRonda2(jugador:j3, cartasAzules:1, cartasVerdes: 1);
      p21mala = PRonda2(jugador:j1, cartasAzules:22, cartasVerdes: 2);
      p21mala2 = PRonda2(jugador:j1, cartasAzules:11, cartasVerdes: 11);
      p22mala = PRonda2(jugador:j2, cartasAzules:2, cartasVerdes: 22);
    });
    test('Jugadores diferentes error',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      expect(()=>p.puntuacionRonda2([p21,p23]), 
      throwsA(TypeMatcher<ProblemaJugadoresDiscordantes>()));
    });
    test('Jugadores puntuando deben ser los mismos de la partida',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      expect(()=>p.puntuacionRonda2([p21,p22]), 
      returnsNormally);
    });
    test('Llamada despues de Ronda 1',(){
      Partida p = Partida(jugadores:{j1, j2});
      expect(()=>p.puntuacionRonda2([p21,p22]), 
      throwsA(TypeMatcher<ProblemaOrdenIncorrecto>()));
    });
    test('Las azules no pueden ser menos que antes',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11mala,p12mala]);
      expect(()=>p.puntuacionRonda2([p21,p22]), 
      throwsA(TypeMatcher<ProblemaAzulesMenosQueAntes>()));
    });
    test('Las azules pueden ser igual o mayores que antes',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      expect(()=>p.puntuacionRonda2([p21,p22]), 
      returnsNormally);
    });
    test('Maximo de azules es 20',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      expect(()=>p.puntuacionRonda2([p21mala,p22]), 
      throwsA(TypeMatcher<ProblemaAzulesMuchas>()));
    });
    test('Maximo de verdes es 20',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      expect(()=>p.puntuacionRonda2([p21,p22mala]), 
      throwsA(TypeMatcher<ProblemaVerdesMuchas>()));
    });
    test('Maximo de ambas cartas debe ser 20',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      expect(()=>p.puntuacionRonda2([p21mala2,p22]), 
      throwsA(TypeMatcher<ProblemaMuchasCartasEnTotal>()));
    });
  });

  group('Puntuacion Ronda 3', (){
    late Jugador j1, j2, j3;
    late PRonda3 p31, p32, p33, p31mala, p32mala, p31mala2, p31mala3, p31mala4, p31mala5;
    late PRonda2 p21, p22, p23, p21mala, p22mala, p21mala2;
    late PRonda1 p11, p12, p13;
    setUp((){
      j1 = Jugador(nombre:'Juan');
      j2 = Jugador(nombre:'Mario');
      j3 = Jugador(nombre:'Jose');

      p11 = PRonda1(jugador:j1, cartasAzules:0);
      p12 = PRonda1(jugador:j2, cartasAzules:0);
      p13 = PRonda1(jugador:j3, cartasAzules:7);

      p21 = PRonda2(jugador:j1, cartasAzules:1, cartasVerdes: 1);
      p22 = PRonda2(jugador:j2, cartasAzules:2, cartasVerdes: 2);
      p23 = PRonda2(jugador:j3, cartasAzules:1, cartasVerdes: 1);
      p21mala = PRonda2(jugador:j1, cartasAzules:6, cartasVerdes: 2);
      p22mala = PRonda2(jugador:j2, cartasAzules:2, cartasVerdes: 6);

      p31 = PRonda3(jugador:j1, cartasAzules:3, cartasVerdes: 3, cartasGrises: 3, cartasRosas: 3);
      p32 = PRonda3(jugador:j2, cartasAzules:4, cartasVerdes: 4, cartasGrises: 4, cartasRosas: 4);
      p33 = PRonda3(jugador:j3, cartasAzules:7, cartasVerdes: 6, cartasGrises: 6, cartasRosas: 3);
      p31mala = PRonda3(jugador:j1, cartasAzules:31, cartasVerdes: 6, cartasGrises: 6, cartasRosas: 3);
      p31mala2 = PRonda3(jugador:j1, cartasAzules:9, cartasVerdes: 31, cartasGrises: 9, cartasRosas: 9);
      p31mala3 = PRonda3(jugador:j1, cartasAzules:9, cartasVerdes: 9, cartasGrises: 31, cartasRosas: 9);
      p31mala4 = PRonda3(jugador:j1, cartasAzules:9, cartasVerdes: 9, cartasGrises: 9, cartasRosas: 31);
      p31mala5 = PRonda3(jugador:j1, cartasAzules:9, cartasVerdes: 9, cartasGrises: 9, cartasRosas:9);
      p32mala = PRonda3(jugador:j2, cartasAzules:7, cartasVerdes: 6, cartasGrises: 6, cartasRosas: 3);
    });
    test('Jugadores diferentes error',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22]);
      expect(()=>p.puntuacionRonda3([p31,p33]), 
      throwsA(TypeMatcher<ProblemaJugadoresDiscordantes>()));
    });
    test('Jugadores puntuando deben ser los mismos de la partida',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22]);
      expect(()=>p.puntuacionRonda3([p31,p32]), 
      returnsNormally);
    });
    test('Llamada despues de Ronda 2',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      expect(()=>p.puntuacionRonda3([p31,p32]), 
      throwsA(TypeMatcher<ProblemaOrdenIncorrecto>()));
    });
    test('Las azules no pueden ser menos que antes',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21mala,p22]);
      expect(()=>p.puntuacionRonda3([p31,p32]), 
      throwsA(TypeMatcher<ProblemaAzulesMenosQueAntes>()));
    });
    test('Las azules pueden ser igual o mayores que antes',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22]);
      expect(()=>p.puntuacionRonda3([p31,p32]), 
      returnsNormally);
    });
    test('Las verdes no pueden ser menos que antes',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22mala]);
      expect(()=>p.puntuacionRonda3([p31,p32]), 
      throwsA(TypeMatcher<ProblemaVerdesMenosQueAntes>()));
    });
    test('Las verdes pueden ser igual o mayores que antes',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22]);
      expect(()=>p.puntuacionRonda3([p31,p32]), 
      returnsNormally);
    });
    test('Maximo de azules es 30',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22]);
      expect(()=>p.puntuacionRonda3([p31mala,p32]), 
      throwsA(TypeMatcher<ProblemaAzulesMuchas>()));
    });
    test('Maximo de verdes es 30',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22]);
      expect(()=>p.puntuacionRonda3([p31mala2,p32]), 
      throwsA(TypeMatcher<ProblemaVerdesMuchas>()));
    });
    test('Maximo de grises es 30',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22]);
      expect(()=>p.puntuacionRonda3([p31mala3,p32]), 
      throwsA(TypeMatcher<ProblemaGrisesMuchas>()));
    });
    test('Maximo de rosas es 30',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22]);
      expect(()=>p.puntuacionRonda3([p31mala4,p32]), 
      throwsA(TypeMatcher<ProblemaRosasMuchas>()));
    });

    test('Maximo de todas las cartas debe ser 30',(){
      Partida p = Partida(jugadores:{j1, j2});
      p.puntuacionRonda1([p11,p12]);
      p.puntuacionRonda2([p21,p22]);
      expect(()=>p.puntuacionRonda3([p31mala5,p32]),
      throwsA(TypeMatcher<ProblemaMuchasCartasEnTotal>()));
    });
  });

}