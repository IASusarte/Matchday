import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class EvaluationApi {
  static Future<Map<String, dynamic>?> crearEvaluacion({
    required int idPartida,
    required int idEvaluador,
    required int idEvaluado,
    required int compromiso,
    required int puntualidad,
    required int fairplay,
    required int nivelJuego,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/evaluaciones'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_partida': idPartida,
        'id_evaluador': idEvaluador,
        'id_evaluado': idEvaluado,
        'compromiso': compromiso,
        'puntualidad': puntualidad,
        'fairplay': fairplay,
        'nivel_juego': nivelJuego,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}