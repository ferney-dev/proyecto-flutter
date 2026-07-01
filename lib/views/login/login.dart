import 'package:app_bienestarmisena_v1/components/login/login_button.dart';
import 'package:app_bienestarmisena_v1/components/login/login_footer.dart';
import 'package:app_bienestarmisena_v1/components/login/login_form_field.dart';
import 'package:app_bienestarmisena_v1/components/login/login_header.dart';
import 'package:app_bienestarmisena_v1/controllers/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/widgets/accesibilidad_bar.dart';
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
  final LoginController loginController = Get.put(LoginController());

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
  // 🧩 INTERFAZ RESPONSIVE
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // Barra de accesibilidad
          const AccesibilidadBar(showScrollButtons: false),
          
          // Contenido principal
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [
                          const Color(0xFF1a1a2e),
                          const Color(0xFF16213e),
                          const Color(0xFF0f3460),
                        ]
                      : [
                          Colors.blue.shade50,
                          Colors.white,
                          Colors.blue.shade100,
                        ],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: ancho * 0.06,
                      vertical: alto * 0.04,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF1e1e2e)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🖼️ Header con logo y título
                            const LoginHeader(),

                            // 📧 Correo
                            LoginFormField(
                              controller: loginController.userController,
                              label: "Correo Electrónico",
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),

                            // 🔒 Contraseña
                            Obx(() => LoginFormField(
                              controller: loginController.passController,
                              label: "Contraseña",
                              prefixIcon: Icons.lock_outline,
                              obscureText: !loginController.showPassword.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  loginController.showPassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () =>
                                    loginController.showPassword.toggle(),
                              ),
                            )),
                            const SizedBox(height: 30),

                            // 🚪 Botón ingresar
                            Obx(() => LoginButton(
                              onPressed: loginController.loading.value
                                  ? null
                                  : () => loginController.login(context),
                              isLoading: loginController.loading.value,
                            )),
                            const SizedBox(height: 20),

                            // 🔗 Footer con enlaces
                            LoginFooter(
                              onRegisterPressed: _goToRegistro,
                              onForgotPasswordPressed: _goToRecuperar,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
