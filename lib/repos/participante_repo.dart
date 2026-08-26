import '../data/test_data.dart';
import '../models/participante_partida.dart';

class ParticipanteRepo {
  List<ParticipantePartida> obtenerParticipantes() {
    return testParticipantes;
  }
}