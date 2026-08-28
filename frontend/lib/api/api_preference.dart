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
}