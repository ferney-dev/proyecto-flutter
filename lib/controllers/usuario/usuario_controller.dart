import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:app_bienestarmisena_v1/models/usuarioModel/usuariosModel.dart';

class UserController extends GetxController {
  final RxBool loading = false.obs;

  // 🔹 Obtener lista de usuarios
  Future<List<UserModel>> getUsers() async {
    try {
      loading.value = true;
      final response = await http.get(Uri.parse(UserModel.apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map && jsonData.containsKey("data")) {
          List users = jsonData["data"];
          return users.map((u) => UserModel.fromJson(u)).toList();
        } else {
          print("⚠️ Respuesta inesperada: $jsonData");
          return [];
        }
      } else {
        print("❌ Error HTTP: ${response.statusCode} => ${response.body}");
        return [];
      }
    } catch (e) {
      print("❌ Error en conexión: $e");
      return [];
    } finally {
      loading.value = false;
    }
  }

  // 🔹 Crear usuario
  Future<bool> crearUsuario(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(UserModel.apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Error creando usuario: $e");
      return false;
    }
  }

  // 🔹 Editar usuario
  Future<bool> editarUsuario(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse("${UserModel.apiUrl}/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error editando usuario: $e");
      return false;
    }
  }

  // 🔹 Eliminar usuario
  Future<bool> eliminarUsuario(int id) async {
    try {
      final response = await http.delete(Uri.parse("${UserModel.apiUrl}/$id"));
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("❌ Error eliminando usuario: $e");
      return false;
    }
  }
}
