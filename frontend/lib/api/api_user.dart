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
      Uri.parse(
        "${ApiConfig.baseUrl}/usuarios",
      ),
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

    if (response.statusCode == 200) {

      return jsonDecode(
        response.body,
      );

    }

    return null;
  }
}