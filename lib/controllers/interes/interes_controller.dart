import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_bienestarmisena_v1/models/interes/interes_model.dart';

class InteresController {
  final String baseUrl = "http://localhost:4000/api/v1/interests";

  // 🔹 Obtener todos los intereses
  Future<List<Interes>> getIntereses() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List lista = data["data"];
        return lista.map((e) => Interes.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Error getIntereses: $e");
      return [];
    }
  }

  // 🔹 Crear interés
  Future<bool> crearInteres(Map<String, dynamic> payload) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      print("❌ Error crearInteres: $e");
      return false;
    }
  }

  // 🔹 Editar interés
  Future<bool> editarInteres(int id, Map<String, dynamic> payload) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error editarInteres: $e");
      return false;
    }
  }

  // 🔹 Eliminar interés
  Future<bool> eliminarInteres(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error eliminarInteres: $e");
      return false;
    }
  }
}
