import '../data/test_data.dart';
import '../models/evaluacion.dart';

class EvaluacionRepo {
  List<Evaluacion> obtenerEvaluaciones() {
    return testEvaluaciones;
  }
}