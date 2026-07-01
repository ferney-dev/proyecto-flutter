import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/views/interface/inicio.dart';

class LoginController extends GetxController {
  // ============================================================
  // 🔹 Estado del login
  // ============================================================
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  var showPassword = false.obs;
  var loading = false.obs;

  // ============================================================
  // 🔹 Controladores globales
  // ============================================================
  final Reactcontroller reactController = Get.find<Reactcontroller>();
  final FavoritesController favoritesController = Get.find<FavoritesController>();

  // ============================================================
  // 🔐 LOGIN
  // ============================================================
  Future<void> login(BuildContext context) async {
    final email = userController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog(context, "Error", "Por favor ingresa correo y contraseña.");
      return;
    }

    loading.value = true;

    try {
      final url = Uri.parse("http://localhost:4000/api/v1/auths/authenticate");
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(res.body);
      debugPrint("📩 RESPUESTA DEL BACKEND: $data");

      if (res.statusCode == 200) {
        // 🔹 El backend puede devolver {user: {...}} o {data: [...]}
        final user = (data["user"] ?? (data["data"]?[0])) ?? {};

        if (user.isEmpty) {
          _showDialog(context, "Error", "No se encontró información del usuario.");
          return;
        }

        final userId = user["uId"] ?? user["id"] ?? 0;

        // ✅ Limpia datos anteriores y guarda el nuevo usuario
        reactController.clearUser();
        reactController.setUser(
          userId,
          user["name"] ?? user["nombre"] ?? "Usuario",
          user["correo"] ??
              user["correo_electronico"] ??
              user["user_email"] ??
              user["email"] ??
              "",
          user["foto"] ??
              user["imagen"] ??
              user["imgUser"] ??
              user["image"] ??
              "",
          user["rol_id"] ?? user["role_id"] ?? user["rolId"] ?? 0,
        );

        // ✅ Limpia y carga los favoritos del usuario actual
        favoritesController.clearFavorites();
        await favoritesController.loadUserFavorites(userId);

        print("🟢 Usuario logueado: ID=$userId | Nombre=${user["name"]}");

        // ✅ Mostrar mensaje de éxito
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Éxito"),
            content: Text("¡Bienvenido ${user["name"]}! 🎉"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );

        // ✅ Ir al inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Inicio()),
        );
      } else {
        _showDialog(context, "Error", data["message"] ?? "Credenciales incorrectas.");
      }
    } catch (e) {
      _showDialog(context, "Error", "No se pudo conectar con el servidor.");
      debugPrint("❌ Error de login: $e");
    } finally {
      loading.value = false;
    }
  }

  // ============================================================
  // 🔹 Diálogo reutilizable
  // ============================================================
  void _showDialog(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 Limpiar controladores
  // ============================================================
  @override
  void onClose() {
    userController.dispose();
    passController.dispose();
    super.onClose();
  }
}
