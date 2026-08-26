import '../data/test_data.dart';
import '../models/partida.dart';

class PartidaRepo {
  List<Partida> obtenerPartidas() {
    return testPartidas;
  }

  void crearPartida(
    Partida partida
  ) {
    testPartidas.add(partida);
  }

  Partida? obtenerId(int id) {
    try{
      return testPartidas.firstWhere(
        (p) => p.id == id
      );
    } catch(_){
      return null;
    }
  }
}