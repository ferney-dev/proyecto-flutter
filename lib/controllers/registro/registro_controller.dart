import 'package:app_bienestarmisena_v1/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/registro/registro_controller_old.dart' show UserController;
import 'package:app_bienestarmisena_v1/models/registroUser/registro.dart';

class RegistroController extends GetxController {
  // ============================================================
  // 🔹 Estado del registro
  // ============================================================
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  var showPassword = false.obs;

  // ============================================================
  // 🔹 Controller existente
  // ============================================================
  final UserController userController = Get.put(UserController());

  // ============================================================
  // 🔐 REGISTRO
  // ============================================================
  Future<void> register(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Todos los campos son obligatorios",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    User newUser = User(
      name: nameController.text,
      email: emailController.text,
      password: passController.text,
    );

    bool success = await userController.registerUser(newUser);

    if (success) {
      Get.snackbar(
        "Éxito",
        "Usuario registrado correctamente",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      Get.snackbar(
        "Error",
        "No se pudo registrar el usuario",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ============================================================
  // 🔹 Limpiar controladores
  // ============================================================
  @override
  void onClose() {
    userController.dispose();
    emailController.dispose();
    passController.dispose();
    super.onClose();
  }
}
