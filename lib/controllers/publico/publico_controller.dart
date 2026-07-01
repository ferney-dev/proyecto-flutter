import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/publicoObejtivoModel/publicoObjetivo.dart';
import 'package:http/http.dart' as http;

/// Controlador encargado de gestionar los Públicos Objetivo.
/// Se comunica con el backend a través de peticiones HTTP REST.
class PublicoObjetivoController {
  /// URL base del endpoint de públicos objetivo.
  final String baseUrl = "http://localhost:4000/api/v1/targetAudiences";

  // ================================================================
  // 🔹 Obtener todos los públicos objetivos
  // ================================================================
  Future<List<PublicoModel>> getPublicoObjetivo() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List lista = data["data"] ?? [];

        // ✅ Se utiliza la clase PublicoModel (no PublicoObjetivo)
        return lista.map((e) => PublicoModel.fromJson(e)).toList();
      } else {
        print("❌ Error HTTP: ${res.statusCode} - ${res.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("⚠️ Error cargando públicos: $e");
      return [];
    }
  }

  // ================================================================
  // 🔹 Crear nuevo público objetivo
  // ================================================================
  Future<bool> crearPublicoObjetivo(Map<String, dynamic> body) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        print("✅ Público objetivo creado correctamente");
        return true;
      } else {
        print("⚠️ Error al crear público: ${res.statusCode} - ${res.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Excepción al crear público: $e");
      return false;
    }
  }

  // ================================================================
  // 🔹 Editar público objetivo existente
  // ================================================================
  Future<bool> editarPublicoObjetivo(int id, Map<String, dynamic> body) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        print("✅ Público objetivo actualizado correctamente");
        return true;
      } else {
        print("⚠️ Error al editar público: ${res.statusCode} - ${res.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Excepción al editar público: $e");
      return false;
    }
  }

  // ================================================================
  // 🔹 Eliminar público objetivo
  // ================================================================
  Future<bool> eliminarPublicoObjetivo(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));

      if (res.statusCode == 200 || res.statusCode == 204) {
        print("🗑️ Público objetivo eliminado correctamente");
        return true;
      } else {
        print("⚠️ Error al eliminar público: ${res.statusCode} - ${res.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Excepción al eliminar público: $e");
      return false;
    }
  }
}
