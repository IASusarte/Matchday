import '../data/test_data.dart';
import '../models/deporte.dart';

class DeporteRepo {
  List<Deporte> obtenerDeportes() {
    return testDeportes;
  }

  Deporte? obtenerId(int id){

    try{
      return testDeportes.firstWhere(
        (d) => d.id == id
      );
    } catch (_){
      return null;
    }
  }
}