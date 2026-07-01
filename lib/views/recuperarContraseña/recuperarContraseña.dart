import 'package:app_bienestarmisena_v1/components/recuperar/recuperar_button.dart';
import 'package:app_bienestarmisena_v1/components/recuperar/recuperar_form_field.dart';
import 'package:app_bienestarmisena_v1/components/recuperar/recuperar_header.dart';
import 'package:app_bienestarmisena_v1/controllers/recuperarContraseña/recuperar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/widgets/accesibilidad_bar.dart';

class OlvidarContrasena extends StatefulWidget {
  const OlvidarContrasena({super.key});

  @override
  State<OlvidarContrasena> createState() => _OlvidarContrasenaState();
}

class _OlvidarContrasenaState extends State<OlvidarContrasena> {
  final RecuperarController recuperarController = Get.put(RecuperarController());

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
                      constraints: const BoxConstraints(maxWidth: 520),
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
                            const RecuperarHeader(),
                            const SizedBox(height: 30),

                            // Paso 1: Ingresar correo
                            Obx(() {
                              if (!recuperarController.mostrarCodigo.value && 
                                  !recuperarController.mostrarReset.value) {
                                return Column(
                                  children: [
                                    RecuperarFormField(
                                      controller: recuperarController.emailController,
                                      label: "Correo Electrónico",
                                      prefixIcon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 20),
                                    RecuperarButton(
                                      onPressed: recuperarController.loading.value
                                          ? null
                                          : () => recuperarController.enviarCorreo(context),
                                      isLoading: recuperarController.loading.value,
                                      text: "Enviar Código",
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            }),

                            // Paso 2: Ingresar código
                            Obx(() {
                              if (recuperarController.mostrarCodigo.value) {
                                return Column(
                                  children: [
                                    RecuperarFormField(
                                      controller: recuperarController.codigoController,
                                      label: "Código de Verificación",
                                      prefixIcon: Icons.confirmation_number_outlined,
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                    ),
                                    const SizedBox(height: 20),
                                    RecuperarButton(
                                      onPressed: recuperarController.loading.value
                                          ? null
                                          : () => recuperarController.verificarCodigo(context),
                                      isLoading: recuperarController.loading.value,
                                      text: "Verificar Código",
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            }),

                            // Paso 3: Resetear contraseña
                            Obx(() {
                              if (recuperarController.mostrarReset.value) {
                                return Column(
                                  children: [
                                    Obx(() => RecuperarFormField(
                                      controller: recuperarController.passController,
                                      label: "Nueva Contraseña",
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: !recuperarController.mostrarPassword.value,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          recuperarController.mostrarPassword.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey.shade600,
                                        ),
                                        onPressed: () =>
                                            recuperarController.mostrarPassword.toggle(),
                                      ),
                                    )),
                                    const SizedBox(height: 20),
                                    Obx(() => RecuperarFormField(
                                      controller: recuperarController.confirmarPassController,
                                      label: "Confirmar Contraseña",
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: !recuperarController.mostrarConfirmarPassword.value,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          recuperarController.mostrarConfirmarPassword.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey.shade600,
                                        ),
                                        onPressed: () =>
                                            recuperarController.mostrarConfirmarPassword.toggle(),
                                      ),
                                    )),
                                    const SizedBox(height: 20),
                                    RecuperarButton(
                                      onPressed: recuperarController.loading.value
                                          ? null
                                          : () => recuperarController.resetPassword(context),
                                      isLoading: recuperarController.loading.value,
                                      text: "Guardar Nueva Contraseña",
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            }),
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
