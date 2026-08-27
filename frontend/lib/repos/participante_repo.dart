import '../data/test_data.dart';
import '../models/participante_partida.dart';

class ParticipanteRepo {
  List<ParticipantePartida> obtenerParticipantes() {
    return testParticipantes;
  }

  void agregarParticipante(
    ParticipantePartida participante
  ){
    testParticipantes.add(participante);
  }
}