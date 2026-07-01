import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class RecuperarController extends GetxController {
  // ============================================================
  // 🔹 Estado de recuperación
  // ============================================================
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmarPassController = TextEditingController();
  
  var loading = false.obs;
  var mostrarCodigo = false.obs;
  var mostrarReset = false.obs;
  var mostrarPassword = false.obs;
  var mostrarConfirmarPassword = false.obs;

  // ============================================================
  // 👉 Enviar correo con código
  // ============================================================
  Future<void> enviarCorreo(BuildContext context) async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showSnack(context, "Por favor ingresa tu correo");
      return;
    }

    loading.value = true;
    try {
      final res = await http.post(
        Uri.parse("http://localhost:4000/api/v1/auths/forgotPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _showSnack(context, "✅ Código enviado a tu correo");
        mostrarCodigo.value = true;
      } else {
        _showSnack(context, "⚠️ ${data["message"] ?? "No se pudo enviar el código"}");
      }
    } catch (e) {
      _showSnack(context, "❌ Error de conexión");
    } finally {
      loading.value = false;
    }
  }

  // ============================================================
  // 👉 Verificar código
  // ============================================================
  Future<void> verificarCodigo(BuildContext context) async {
    if (codigoController.text.length != 6) {
      _showSnack(context, "El código debe tener 6 dígitos");
      return;
    }

    loading.value = true;
    try {
      final res = await http.post(
        Uri.parse("http://localhost:4000/api/v1/auths/verifyCode"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "code": codigoController.text.trim()
        }),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _showSnack(context, "✅ Código válido, ahora ingresa tu nueva contraseña");
        mostrarCodigo.value = false;
        mostrarReset.value = true;
      } else {
        _showSnack(context, "⚠️ ${data["message"] ?? "Código inválido"}");
      }
    } catch (e) {
      _showSnack(context, "❌ Error al verificar código");
    } finally {
      loading.value = false;
    }
  }

  // ============================================================
  // 👉 Resetear contraseña
  // ============================================================
  Future<void> resetPassword(BuildContext context) async {
    final pass = passController.text.trim();
    final confirm = confirmarPassController.text.trim();

    if (pass.length < 6) {
      _showSnack(context, "La contraseña debe tener al menos 6 caracteres");
      return;
    }
    if (pass != confirm) {
      _showSnack(context, "Las contraseñas no coinciden");
      return;
    }

    loading.value = true;
    try {
      final res = await http.post(
        Uri.parse("http://localhost:4000/api/v1/auths/resetPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "code": codigoController.text.trim(),
          "newPassword": pass
        }),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _showSnack(context, "✅ Contraseña actualizada correctamente");
        Navigator.pop(context); // Regresa al login
      } else {
        _showSnack(context, "⚠️ ${data["message"] ?? "No se pudo actualizar"}");
      }
    } catch (e) {
      _showSnack(context, "❌ Error de conexión");
    } finally {
      loading.value = false;
    }
  }

  // ============================================================
  // 🔹 SnackBar
  // ============================================================
  void _showSnack(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), duration: const Duration(seconds: 2)),
    );
  }

  // ============================================================
  // 🔹 Limpiar controladores
  // ============================================================
  @override
  void onClose() {
    emailController.dispose();
    codigoController.dispose();
    passController.dispose();
    confirmarPassController.dispose();
    super.onClose();
  }
}
