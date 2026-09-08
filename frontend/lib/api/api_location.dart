import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class LocationApi {
  static Future<List<dynamic>>
  obtenerUbicaciones() async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/ubicaciones',
      ),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<Map<String, dynamic>?>
  obtenerUbicacion(
    int idUbicacion,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/ubicaciones/$idUbicacion',
      ),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
  
  static Future<List<dynamic>>
  obtenerUbicacionesPorDeporte(
    int idDeporte,
  ) async {

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/ubicaciones/deporte/$idDeporte',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }
}