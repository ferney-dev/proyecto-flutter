import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:app_bienestarmisena_v1/models/Favoritos/favoritos.dart';

class FavoritesController extends GetxController {
  // 🌐 URL base
  final String baseUrl = "http://localhost:4000/api/v1/favorites";

  // ✅ Lista reactiva de favoritos (para manejo dinámico en UI)
  var favoritesList = <FavoriteModel>[].obs;

  // ===============================================================
  // 🔹 LIMPIAR FAVORITOS (por ejemplo, al cerrar sesión)
  // ===============================================================
  void clearFavorites() {
    favoritesList.clear();
    print("🧹 Lista de favoritos limpiada correctamente.");
  }

  // ===============================================================
  // 🔹 CARGAR FAVORITOS POR USUARIO
  // ===============================================================
 Future<void> loadUserFavorites(int userId) async {
  try {
    favoritesList.clear();

    final res = await http.get(Uri.parse("$baseUrl/user/$userId"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List<dynamic> list = data["data"] ?? [];
      favoritesList.value =
          list.map((item) => FavoriteModel.fromJson(item)).toList();

      print("✅ Favoritos cargados para usuario $userId: ${favoritesList.length}");
    } else {
      print("⚠️ Error al obtener favoritos (status ${res.statusCode})");
    }
  } catch (e) {
    print("❌ Error cargando favoritos: $e");
  }
}


  // ===============================================================
  // 🔹 AGREGAR FAVORITO
  // ===============================================================
  Future<FavoriteModel?> addFavorite(int userId, int callId) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "callId": callId,
        }),
      );

      print("📌 addFavorite (${res.statusCode}): ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        final fav = FavoriteModel.fromJson(data["data"]);
        favoritesList.add(fav);
        print("✅ Favorito agregado correctamente: ${fav.id}");
        return fav;
      } else {
        print("⚠️ Error al agregar favorito (${res.statusCode}): ${res.body}");
      }
    } catch (e) {
      print("❌ Error agregando favorito: $e");
    }
    return null;
  }

  // ===============================================================
  // 🔹 ELIMINAR FAVORITO
  // ===============================================================
  Future<bool> removeFavorite(int favoriteId) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$favoriteId"));
      if (res.statusCode == 200) {
        favoritesList.removeWhere((f) => f.id == favoriteId);
        print("🗑️ Favorito eliminado correctamente (ID: $favoriteId)");
        return true;
      } else {
        print("⚠️ Error al eliminar favorito (${res.statusCode})");
      }
    } catch (e) {
      print("❌ Error eliminando favorito: $e");
    }
    return false;
  }

  // ===============================================================
  // 🔹 CREAR FAVORITO (modo tradicional CRUD)
  // ===============================================================
  Future<bool> crearFavorite(int userId, int callId) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "callId": callId,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("✅ Favorito creado correctamente");
        return true;
      } else {
        print("⚠️ Error al crear favorito: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Error crearFavorite: $e");
      return false;
    }
  }

  // ===============================================================
  // 🔹 EDITAR FAVORITO (modo tradicional CRUD)
  // ===============================================================
  Future<bool> editarFavorite(int id, int userId, int callId) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "callId": callId,
        }),
      );

      if (res.statusCode == 200) {
        print("✅ Favorito actualizado correctamente (ID: $id)");
        return true;
      } else {
        print("⚠️ Error al editar favorito (${res.statusCode})");
        return false;
      }
    } catch (e) {
      print("❌ Error editarFavorite: $e");
      return false;
    }
  }

  // ===============================================================
  // 🔹 ELIMINAR FAVORITO (modo tradicional CRUD)
  // ===============================================================
  Future<bool> eliminarFavorite(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"));
      if (res.statusCode == 200) {
        favoritesList.removeWhere((f) => f.id == id);
        print("🗑️ Favorito eliminado (ID: $id)");
        return true;
      } else {
        print("⚠️ Error al eliminar favorito (${res.statusCode})");
        return false;
      }
    } catch (e) {
      print("❌ Error eliminarFavorite: $e");
      return false;
    }
  }
}
