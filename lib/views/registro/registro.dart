import 'package:app_bienestarmisena_v1/controllers/registro.dart' show UserController;
import 'package:app_bienestarmisena_v1/models/registroUser/registro.dart';
import 'package:app_bienestarmisena_v1/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final UserController userController = Get.put(UserController());

  bool _showPassword = false;

  final Color verde = const Color(0xFF39A900);

  Future<void> _register() async {
    if (_userController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Todos los campos son obligatorios")),
      );
      return;
    }

    User newUser = User(
      name: _userController.text,
      email: _emailController.text,
      password: _passController.text,
    );

    bool success = await userController.registerUser(newUser);

    if (success) {
      Get.snackbar("Éxito", "Usuario registrado correctamente",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      // 👇 Aquí lo llevamos a Login en vez de Inicio
      Get.offAll(() => const Login());

    } else {
      Get.snackbar("Error", "No se pudo registrar el usuario",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: verde.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("img/convo2.png", height: 130),
                const SizedBox(height: 20),
                Text(
                  "Crear Cuenta",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: verde,
                  ),
                ),
                const SizedBox(height: 40),

                _buildTextField("Nombre de Usuario", Icons.person, _userController),
                const SizedBox(height: 20),

                _buildTextField("Correo Electrónico", Icons.mail, _emailController,
                    keyboard: TextInputType.emailAddress),
                const SizedBox(height: 20),

                _buildTextFieldPassword("Contraseña", _passController, _showPassword,
                    (v) => setState(() => _showPassword = !_showPassword)),
                const SizedBox(height: 30),

                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed:
                            userController.loading.value ? null : () => _register(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: verde,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: userController.loading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Registrarse",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    )),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "¿Ya tienes una cuenta? Volver a Inicio de Sesión",
                    style: TextStyle(
                        color: verde, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: verde, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildTextFieldPassword(String label, TextEditingController controller,
      bool showPassword, Function(bool) toggle) {
    return TextField(
      controller: controller,
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey),
          onPressed: () => toggle(!showPassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: verde, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
