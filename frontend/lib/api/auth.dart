import 'dart:convert';
import 'package:http/http.dart' as http;

import 'config.dart';

class AuthApi {

  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    //print("${ApiConfig.baseUrl}/login");
    

    final response = await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}/login",
      ),
      headers: {
        "Content-Type":
            "application/json"
      },
      body: jsonEncode({
        "email": email,
        "password": password,
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