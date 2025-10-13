import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// 🧩 Controladores globales
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';

// 🧩 Vistas
import '../interface/inicio.dart';
import '../recuperarContraseña/recuperarContraseña.dart' hide Inicio;
import 'package:app_bienestarmisena_v1/views/registro/registro.dart'
    hide Inicio;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;

  final Color verde = const Color(0xFF39A900);

  // ✅ Controladores globales de usuario y favoritos
  final Reactcontroller reactController = Get.find<Reactcontroller>();
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  // ============================================================
  // 🔐 LOGIN
  // ============================================================
  Future<void> _login() async {
    final email = userController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog("Error", "Por favor ingresa correo y contraseña.");
      return;
    }

    setState(() => _loading = true);

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
          _showDialog("Error", "No se encontró información del usuario.");
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
        _showDialog("Error", data["message"] ?? "Credenciales incorrectas.");
      }
    } catch (e) {
      _showDialog("Error", "No se pudo conectar con el servidor.");
      debugPrint("❌ Error de login: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  // ============================================================
  // 🔹 Navegación
  // ============================================================
  void _goToRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Registro()),
    );
  }

  void _goToRecuperar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OlvidarContrasena()),
    );
  }

  // ============================================================
  // 🔹 Diálogo reutilizable
  // ============================================================
  void _showDialog(String titulo, String mensaje) {
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
  // 🧩 INTERFAZ RESPONSIVE
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ancho * 0.08,
              vertical: alto * 0.05,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: verde.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🖼️ Logo
                    Image.asset(
                      "img/convo2.png",
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 25),

                    const Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 35),

                    // 📧 Correo
                    TextField(
                      controller: userController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Correo Electrónico",
                        prefixIcon:
                            const Icon(Icons.mail_outline, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: verde, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // 🔒 Contraseña
                    TextField(
                      controller: passController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: verde, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // 🚪 Botón ingresar
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: verde,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Ingresar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // 🔹 Enlaces adicionales
                    TextButton(
                      onPressed: _goToRegistro,
                      child: Text(
                        "¿No tienes una cuenta? Regístrate aquí",
                        style: TextStyle(
                          color: verde,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _goToRecuperar,
                      child: Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(
                          color: verde,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🧩 Pie de página (opcional)
                    Text(
                      "Bienestar MiSena © 2025",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
