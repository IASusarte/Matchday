import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiSports {

static Future<List<dynamic>> obtenerDeportes() async {

  final response = await http.get(
    Uri.parse(
      "${ApiConfig.baseUrl}/deportes",
    ),
  );

  return jsonDecode(response.body);
}
}