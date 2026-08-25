import '../models/evaluacion.dart';

double calcularPromedio(
  List<Evaluacion> evaluaciones, 
  int Function(Evaluacion e) selector,
)  {
  if (evaluaciones.isEmpty) {
    return 0;
  }
  double suma = 0;
    for (var e in evaluaciones) {

      suma += selector(e);
    }
    return suma / evaluaciones.length;
  }

