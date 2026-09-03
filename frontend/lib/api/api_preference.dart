import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiPreference {

static Future<void> agregarPreferencia(
  int idUsuario,
  int idDeporte,
) async {

  await http.post(
    Uri.parse(
      "${ApiConfig.baseUrl}/usuarios/$idUsuario/preferencias",
    ),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "id_usuario": idUsuario,
      "id_deporte": idDeporte,
    }),
  );
}

static Future<List<dynamic>> obtenerPreferencias(
  int id,
) async {

  final response = await http.get(
    Uri.parse(
      "${ApiConfig.baseUrl}/usuarios/$id/preferencias",
    ),
  );

  return jsonDecode(
    response.body,
  );
}

static Future<void> eliminarPreferencia(
  int idUsuario,
  int idDeporte,
) async {

  await http.delete(
    Uri.parse(
      "${ApiConfig.baseUrl}/usuarios/$idUsuario/preferencias/$idDeporte",
    ),
  );
}
}