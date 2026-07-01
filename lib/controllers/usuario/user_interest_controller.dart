import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';
import 'package:http/http.dart' as http;

class UserInterestsController {
  // 🌐 URL base del backend
  final String baseUrl = "http://localhost:4000/api/v1/userInterests";

  // ============================================================
  // 🔹 Obtener todos los userInterests
  // ============================================================
  Future<List<UserInterest>> obtenerUserInterests() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List lista = data["data"];
        return lista.map((e) => UserInterest.fromJson(e)).toList();
      } else {
        print("⚠️ Error ${res.statusCode}: ${res.body}");
        throw Exception("Error al obtener los userInterests");
      }
    } catch (e) {
      print("❌ Excepción al obtener userInterests: $e");
      rethrow;
    }
  }

  // ============================================================
  // 🔹 Obtener intereses por ID de usuario
  // ============================================================
 Future<List<UserInterest>> getInteresesByUser(int userId) async {
  try {
    final url = Uri.parse(baseUrl); // ✅ Trae todos los intereses
    print("📡 Solicitando intereses desde: $url para userId=$userId");

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List lista = data["data"];

      // 🔍 Filtra los intereses SOLO del usuario logueado
      final filtrados = lista
          .where((e) => e["user"] != null && e["user"]["id"] == userId)
          .toList();

      print("✅ Intereses encontrados para userId=$userId → ${filtrados.length}");

      // 🔁 Convierte a modelo
      return filtrados.map((e) => UserInterest.fromJson(e)).toList();
    } else if (res.statusCode == 404) {
      print("⚠️ No se encontraron intereses para el usuario $userId");
      return [];
    } else {
      print("⚠️ Error ${res.statusCode}: ${res.body}");
      throw Exception("Error al obtener intereses del usuario");
    }
  } catch (e) {
    print("❌ Excepción al obtener intereses por usuario: $e");
    rethrow;
  }
}


  // ============================================================
  // 🔹 Crear un nuevo userInterest
  // ============================================================
  Future<bool> crearUserInterest(Map<String, dynamic> body) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        print("✅ UserInterest creado correctamente");
        return true;
      } else {
        print("⚠️ Error ${res.statusCode}: ${res.body}");
        return false;
      }
    } catch (e) {
      print("❌ Excepción al crear userInterest: $e");
      return false;
    }
  }

  // ============================================================
  // 🔹 Editar un userInterest existente
  // ============================================================
  Future<bool> editarUserInterest(
      int userId, int interestId, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse("$baseUrl/$userId/$interestId");
      final res = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        print("✅ UserInterest actualizado correctamente");
        return true;
      } else {
        print("⚠️ Error ${res.statusCode}: ${res.body}");
        return false;
      }
    } catch (e) {
      print("❌ Excepción al editar userInterest: $e");
      return false;
    }
  }

  // ============================================================
  // 🔹 Eliminar un userInterest
  // ============================================================
  Future<bool> eliminarUserInterest(int userId, int interestId) async {
    try {
      final url = Uri.parse("$baseUrl/$userId/$interestId");
      final res = await http.delete(url);

      if (res.statusCode == 200) {
        print("🗑️ UserInterest eliminado correctamente");
        return true;
      } else {
        print("⚠️ Error ${res.statusCode}: ${res.body}");
        return false;
      }
    } catch (e) {
      print("❌ Excepción al eliminar userInterest: $e");
      return false;
    }
  }
}
