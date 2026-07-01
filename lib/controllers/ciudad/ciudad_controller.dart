import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_bienestarmisena_v1/models/cuidad/cuidad.dart';

class CitiesController {
  final String baseUrl = "http://localhost:4000/api/v1/cities";

  // 🔹 Obtener todas las ciudades
  Future<List<City>> getCities() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        return citiesFromJson(res.body);
      } else {
        throw Exception("Error al obtener ciudades");
      }
    } catch (e) {
      print("❌ Error getCities: $e");
      rethrow;
    }
  }

  // 🔹 Crear ciudad
  Future<bool> crearCity(String name, int departmentId) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "departmentId": departmentId,
        }),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      print("❌ Error crearCity: $e");
      return false;
    }
  }

  // 🔹 Editar ciudad
  Future<bool> editarCity(int id, String name, int departmentId) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "departmentId": departmentId,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error editarCity: $e");
      return false;
    }
  }

  // 🔹 Eliminar ciudad
  Future<bool> eliminarCity(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error eliminarCity: $e");
      return false;
    }
  }
}
