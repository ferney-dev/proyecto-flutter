import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/grupoRequisitos/grupoRequisitos.dart';
import 'package:http/http.dart' as http;

class RequirementGroupsController {
  final String baseUrl = "http://localhost:4000/api/v1/requirementGroups";

  // 🔹 Obtener todos los grupos
  Future<List<RequirementGroup>> getRequirementGroups() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        return requirementGroupsFromJson(res.body);
      } else {
        throw Exception("Error al obtener requirementGroups");
      }
    } catch (e) {
      print("❌ Error getRequirementGroups: $e");
      rethrow;
    }
  }

  // 🔹 Crear grupo
  Future<bool> crearRequirementGroup(String name, int categoryId) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "categoryId": categoryId,
        }),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      print("❌ Error crearRequirementGroup: $e");
      return false;
    }
  }

  // 🔹 Editar grupo
  Future<bool> editarRequirementGroup(int id, String name, int categoryId) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "categoryId": categoryId,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error editarRequirementGroup: $e");
      return false;
    }
  }

  // 🔹 Eliminar grupo
  Future<bool> eliminarRequirementGroup(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error eliminarRequirementGroup: $e");
      return false;
    }
  }
}
