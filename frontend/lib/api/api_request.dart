import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class RequestApi {
  static Future<Map<String, dynamic>?> crearSolicitud({
    required int idUsuario,
    required int idPartida,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/solicitudes'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_usuario': idUsuario,
        'id_partida': idPartida,
        'estado': 'Pendiente',
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future<List<dynamic>>
      obtenerSolicitudesDetalle() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/solicitudes/detalle')
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<Map<String, dynamic>?>
    aceptarSolicitud(
      int idPartida,
      int idSolicitud,
    ) async {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/partidas/$idPartida/aceptar/$idSolicitud')
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
  }

  static Future<Map<String, dynamic>?>
    rechazarSolicitud(
      int idPartida,
      int idSolicitud,
    ) async {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/partidas/$idPartida/rechazar/$idSolicitud')
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
  }

  static Future<List<dynamic>>
    obtenerSolicitudesRecibidas(
  int idUsuario,
  ) async {

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/usuarios/$idUsuario/solicitudes-recibidas',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }
}