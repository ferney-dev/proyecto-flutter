import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/departamento/departamento.dart';
import 'package:http/http.dart' as http;

class DepartmentsController {
  final String baseUrl = "http://localhost:4000/api/v1/departments";

  // 🔹 Obtener todos los departamentos
  Future<List<Department>> getDepartments() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        return departmentsFromJson(res.body);
      } else {
        throw Exception("Error al obtener departamentos");
      }
    } catch (e) {
      print("❌ Error en getDepartments: $e");
      rethrow;
    }
  }

  // 🔹 Crear nuevo departamento
  Future<bool> crearDepartment(String name) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      print("❌ Error al crear departamento: $e");
      return false;
    }
  }

  // 🔹 Editar departamento
  Future<bool> editarDepartment(int id, String name) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error al editar departamento: $e");
      return false;
    }
  }

  // 🔹 Eliminar departamento
  Future<bool> eliminarDepartment(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error al eliminar departamento: $e");
      return false;
    }
  }
}
