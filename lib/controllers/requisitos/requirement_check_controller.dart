import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/requerimientosChequeos/requirement_check.dart';
import 'package:http/http.dart' as http;

class RequirementChecksController {
  final String baseUrl = "http://localhost:4000/api/v1/requirementChecks";

  // ============================================================
  // 🔹 Obtener todos los requirementChecks
  // ============================================================
  Future<List<RequirementCheck>> getRequirementChecks() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        return requirementChecksFromJson(res.body);
      } else {
        throw Exception("Error al obtener requirementChecks");
      }
    } catch (e) {
      print("❌ Error getRequirementChecks: $e");
      rethrow;
    }
  }

  // ============================================================
  // 🔹 Crear un requirementCheck individual (no usado en lote)
  // ============================================================
  Future<bool> crearRequirementCheck(String name) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      print("❌ Error crearRequirementCheck: $e");
      return false;
    }
  }

  // ============================================================
  // 🔹 Editar un requirementCheck
  // ============================================================
  Future<bool> editarRequirementCheck(int id, String name) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error editarRequirementCheck: $e");
      return false;
    }
  }

  // ============================================================
  // 🔹 Eliminar un requirementCheck
  // ============================================================
  Future<bool> eliminarRequirementCheck(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error eliminarRequirementCheck: $e");
      return false;
    }
  }

  // ============================================================
  // 🔹 Guardar múltiples requirementChecks (batch)
  // ============================================================
  /// Esta función guarda todos los requisitos marcados por un usuario o empresa.
  /// Recibe una lista de mapas con este formato:
  /// ```dart
  /// [
  ///   {"requirementId": 1, "userId": 5},
  ///   {"requirementId": 2, "userId": 5},
  ///   ...
  /// ]
  /// ```
  /// En el backend se envía como:
  /// ```json
  /// { "data": [ { "requirementId": 1, "userId": 5 }, ... ] }
  /// ```
  Future<bool> guardarRequirementChecks(List<Map<String, dynamic>> checks) async {
    try {
      // Verificamos que la lista no esté vacía
      if (checks.isEmpty) {
        print("⚠️ No hay requirementChecks para guardar.");
        return false;
      }

      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"data": checks}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        print("✅ RequirementChecks guardados correctamente.");
        return true;
      } else {
        print("⚠️ Error ${res.statusCode}: ${res.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error guardarRequirementChecks: $e");
      return false;
    }
  }
}
