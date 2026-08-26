import '../data/test_data.dart';
import '../models/solicitud.dart';

class SolicitudRepo {
  List<Solicitud> obtenerSolicitudes() {
    return testSolicitudes;
  }

  void crearSolicitud(
    Solicitud solicitud
  ) { 
    testSolicitudes.add(solicitud);
  }
}