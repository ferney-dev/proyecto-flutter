import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

class ConvocatoriasController {
  late final String apiUrl;
  late final String baseUrl;

  ConvocatoriasController() {
    apiUrl = dotenv.env['API_URL'] ?? "http://localhost:4000/api/v1/calls";
    baseUrl = dotenv.env['IMAGE_BASE_URL'] ?? "http://localhost:4000";
  }

  // ======================================================
  // 🔹 OBTENER TODAS LAS CONVOCATORIAS
  // ======================================================
  Future<List<Convocatoria>> getConvocatorias() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData["data"];
      return data.map((item) => Convocatoria.fromJson(item, baseUrl: baseUrl)).toList();
    } else {
      throw Exception("Error al cargar convocatorias");
    }
  }

  // ======================================================
  // 🔹 CREAR NUEVA CONVOCATORIA
  // ======================================================
  Future<bool> crearConvocatoria(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ Convocatoria creada correctamente");
        return true;
      } else {
        print("❌ Error al crear convocatoria: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error al crear convocatoria: $e");
      return false;
    }
  }

  // ======================================================
  // 🔹 ACTUALIZAR CONVOCATORIA EXISTENTE
  // ======================================================
  Future<bool> actualizarConvocatoria(int id, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("✅ Convocatoria actualizada correctamente");
        return true;
      } else {
        print("❌ Error al actualizar convocatoria: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error al actualizar convocatoria: $e");
      return false;
    }
  }

  // ======================================================
  // 🔹 ELIMINAR CONVOCATORIA
  // ======================================================
  Future<bool> eliminarConvocatoria(int id) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$id"));

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("🗑️ Convocatoria eliminada correctamente");
        return true;
      } else {
        print("❌ Error al eliminar convocatoria: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error al eliminar convocatoria: $e");
      return false;
    }
  }
}
