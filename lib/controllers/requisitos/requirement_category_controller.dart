import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/requirement_categoryModel/requirement_category.dart';
import 'package:http/http.dart' as http;

class RequirementCategoriesController {
  final String baseUrl = "http://localhost:4000/api/v1/requirementCategories";

  // 🔹 Obtener todas las categorías
  Future<List<RequirementCategory>> getRequirementCategories() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        return requirementCategoriesFromJson(res.body);
      } else {
        throw Exception("Error al obtener requirementCategories");
      }
    } catch (e) {
      print("❌ Error getRequirementCategories: $e");
      rethrow;
    }
  }

  // 🔹 Crear
  Future<bool> crearRequirementCategory(String name) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      print("❌ Error crearRequirementCategory: $e");
      return false;
    }
  }

  // 🔹 Editar
  Future<bool> editarRequirementCategory(int id, String name) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error editarRequirementCategory: $e");
      return false;
    }
  }

  // 🔹 Eliminar
  Future<bool> eliminarRequirementCategory(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error eliminarRequirementCategory: $e");
      return false;
    }
  }
}
