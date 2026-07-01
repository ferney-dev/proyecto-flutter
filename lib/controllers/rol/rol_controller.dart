import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/rol/rol.dart';
import 'package:http/http.dart' as http;

class RolesController {
  final String baseUrl = "http://localhost:4000/api/v1/roles";

  // 🔹 Obtener todos los roles
  Future<List<Rol>> obtenerRoles() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List lista = data["data"];
      return lista.map((e) => Rol.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar roles");
    }
  }

  // 🔹 Crear rol
  Future<bool> crearRol(Map<String, dynamic> rol) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(rol),
    );

    return res.statusCode == 201 || res.statusCode == 200;
  }

  // 🔹 Editar rol
  Future<bool> editarRol(int id, Map<String, dynamic> rol) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(rol),
    );
    return res.statusCode == 200;
  }

  // 🔹 Eliminar rol
  Future<bool> eliminarRol(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    return res.statusCode == 200;
  }
}
