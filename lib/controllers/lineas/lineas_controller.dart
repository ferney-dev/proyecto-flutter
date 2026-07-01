import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';
import 'package:http/http.dart' as http;

class LineasController {
  final String baseUrl = "http://localhost:4000/api/v1/lines"; // 🔹 tu endpoint backend

  Future<List<Linea>> getLineas() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Si tu backend devuelve { "data": [...] }
        final List data = jsonData['data'] ?? jsonData;

        // Convertir JSON en lista de objetos Linea
        return data.map((item) => Linea.fromJson(item)).toList();
      } else {
        throw Exception("Error al obtener líneas: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error en getLineas(): $e");
      return [];
    }
  }

    Future<bool> crearLinea(Map<String, dynamic> data) async {
    try {
      final res = await http.post(Uri.parse(baseUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      print("❌ Error en crearLinea(): $e");
      return false;
    }
  }

  Future<bool> editarLinea(int id, Map<String, dynamic> data) async {
    try {
      final res = await http.put(Uri.parse("$baseUrl/$id"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error en editarLinea(): $e");
      return false;
    }
  }

  Future<bool> eliminarLinea(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error en eliminarLinea(): $e");
      return false;
    }
  }

}
