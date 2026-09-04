import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class UserApi {
  

  static Future<Map<String, dynamic>?> crearUsuario({
    required String rut,
    required String nombres,
    required String apellidos,
    required String email,
    required String nickname,
    required String password,
    required String fechaNacimiento,
    required String sexo,
  }) async {

    

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/usuarios",),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "rut": rut,
        "nombres": nombres,
        "apellidos": apellidos,
        "email": email,
        "nickname": nickname,
        "password": password,
        "fecha_nacimiento": fechaNacimiento,
        "sexo": sexo,
      }),
    );


      return jsonDecode(
        response.body,
      );

  }

  static Future<Map<String, dynamic>?> obtenerUsuario(int id) 
    async {

  final response = await http.get(
    Uri.parse("${ApiConfig.baseUrl}/usuarios/$id"),
  );

  if (response.statusCode == 200) {

    return jsonDecode(
      response.body,
    );
  }

  return null;
  }

  static Future<Map<String, dynamic>?> actualizarPerfil(
    int id,
    String email,
    String nickname,
    String passwordActual
  ) async {

  final response = await http.put(
    Uri.parse("${ApiConfig.baseUrl}/usuarios/$id/perfil",),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "email": email,
        "nickname": nickname,
        "password_actual": passwordActual
      }),
  );

    return jsonDecode(
      response.body,
    );

  }  

  static Future<Map<String, dynamic>?> cambiarPassword(
    int id,
    String passwordActual,
    String passwordNueva,
  ) async {

    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/usuarios/$id/password"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "password_actual": passwordActual,
      "password_nueva": passwordNueva,
    }),
  );

  return jsonDecode(
    response.body,
  );
  }

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
  
  static Future<List<dynamic>> obtenerHistorial(
    int id,
  ) async {

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/usuarios/$id/historial',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];

  }

  static Future<Map<String, dynamic>?> obtenerDashboard(
  int id,
  ) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/usuarios/$id/dashboard'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
