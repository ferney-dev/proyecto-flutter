import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:get/get.dart';

class Reactcontroller extends GetxController {
  // ====================================================
  // 🔹 Variables reactivas del usuario logueado
  // ====================================================
  var userId = 0.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userImage = ''.obs; // Imagen de perfil
  var roleId = 0.obs; // Rol del usuario (1 = normal, 2 = administrador, etc.)

  // ====================================================
  // 🔹 Variable reactiva para la empresa del usuario
  // ====================================================
  var empresaId = 0.obs; // 👈 ID de la empresa asociada al usuario

  // ====================================================
  // 🔹 Guardar usuario después del login
  // ====================================================
  void setUser(
    int id,
    String name,
    String email,
    String? imageUrl,
    int? role,
  ) {
    userId.value = id;
    userName.value = name;
    userEmail.value = email;
    userImage.value = imageUrl ?? '';
    roleId.value = role ?? 0;
  }

  // ====================================================
  // 🔹 Guardar ID de la empresa del usuario
  // ====================================================
  void setEmpresaId(int id) {
    empresaId.value = id;
  }

  // ====================================================
  // 🔹 Limpiar usuario y empresa al cerrar sesión
  // ====================================================
  void clearUser() {
    userId.value = 0;
    userName.value = "";
    userEmail.value = "";
    userImage.value = "";
    roleId.value = 0;
    empresaId.value = 0;
    Get.find<FavoritesController>().clearFavorites(); // ✅ Limpia favoritos al cerrar sesión
  }

  // ====================================================
  // 🔹 Método corto para cerrar sesión
  // ====================================================
  void cerrarSesion() {
    clearUser();
  }
}
