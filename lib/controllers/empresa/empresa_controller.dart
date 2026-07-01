import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/empresaModel/empresa_model.dart';
import 'package:http/http.dart' as http;

class EmpresaController {
  final String baseUrl = "http://localhost:4000/api/v1/companies";

  // 🔹 Obtener todas las empresas
  Future<List<Empresa>> getEmpresas() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List lista = data["data"];
        return lista.map((e) => Empresa.fromJson(e)).toList();
      } else {
        throw Exception("Error al cargar empresas: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Error getEmpresas: $e");
      return [];
    }
  }

  // 🔹 Obtener una empresa por ID
  Future<Empresa?> getEmpresaById(int id) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/$id"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Empresa.fromJson(data["data"]);
      } else {
        print("⚠️ No se encontró empresa con ID $id");
        return null;
      }
    } catch (e) {
      print("❌ Error getEmpresaById: $e");
      return null;
    }
  }

  // 🔹 Crear empresa
  Future<bool> crearEmpresa(Map<String, dynamic> body) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      print("❌ Error crearEmpresa: $e");
      return false;
    }
  }

  // 🔹 Actualizar empresa
  Future<bool> actualizarEmpresa(int id, Map<String, dynamic> body) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error actualizarEmpresa: $e");
      return false;
    }
  }

  // 🔹 Eliminar empresa
  Future<bool> eliminarEmpresa(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error eliminarEmpresa: $e");
      return false;
    }
  }

    // ✅ Obtener empresa por ID de usuario
  Future<Empresa?> getEmpresaByUserId(int userId) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/user/$userId"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Empresa.fromJson(data["data"]);
      } else {
        print("⚠️ No se encontró empresa para el usuario con ID $userId");
        return null;
      }
    } catch (e) {
      print("❌ Error getEmpresaByUserId: $e");
      return null;
    }
  }

}
