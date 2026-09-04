import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class MatchApi {

  static Future<Map<String, dynamic>?> crearPartida({
    required int idCreador,
    required int idDeporte,
    required String fecha,
    required String hora,
    required int cantJugadores,
    required String lugar,
    required String descripcion,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/partidas'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_creador': idCreador,
        'id_deporte': idDeporte,
        'fecha': fecha,
        'hora': hora,
        'cant_jugadores': cantJugadores,
        'lugar': lugar,
        'id_ubicacion': null,
        'descripcion': descripcion,
        'estado': 'Activa',
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> obtenerPartidasActivas() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/partidas/activas'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(
        response.body);
    }
    return [];
  }

static Future<Map<String, dynamic>?> obtenerPartida(
  int id,
) async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/partidas/$id'),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
  }

  static Future<List<dynamic>> obtenerParticipantes(
    int idPartida,
  ) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/partidas/$idPartida/participantes'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<List<dynamic>> obtenerParticipantesDetalle(
    int idPartida,
  ) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/partidas/$idPartida/participantes/detalle'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}