import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/requisitosModel/requisitos.dart';
import 'package:http/http.dart' as http;

class RequirementsController {
  final String baseUrl = "http://localhost:4000/api/v1/requirements";

  // 🔹 Obtener todos
  Future<List<Requirement>> getRequirements() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        return requirementsFromJson(res.body);
      } else {
        throw Exception("Error al obtener requisitos");
      }
    } catch (e) {
      print("❌ Error getRequirements: $e");
      rethrow;
    }
  }

  // 🔹 Crear
  Future<bool> crearRequirement(
      String name, String notes, int institutionId, int groupId) async {
    try {
      final res = await http.post(Uri.parse(baseUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "notes": notes,
            "institutionId": institutionId,
            "groupId": groupId
          }));
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print("❌ Error crearRequirement: $e");
      return false;
    }
  }

  // 🔹 Editar
  Future<bool> editarRequirement(
      int id, String name, String notes, int institutionId, int groupId) async {
    try {
      final res = await http.put(Uri.parse("$baseUrl/$id"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "notes": notes,
            "institutionId": institutionId,
            "groupId": groupId
          }));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error editarRequirement: $e");
      return false;
    }
  }

  // 🔹 Eliminar
  Future<bool> eliminarRequirement(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error eliminarRequirement: $e");
      return false;
    }
  }
}
