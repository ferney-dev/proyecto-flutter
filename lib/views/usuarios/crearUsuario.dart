import 'package:app_bienestarmisena_v1/controllers/usuario.dart';
import 'package:flutter/material.dart';

class ModalCrearUsuario extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearUsuario({super.key, required this.onSuccess});

  @override
  State<ModalCrearUsuario> createState() => _ModalCrearUsuarioState();
}

class _ModalCrearUsuarioState extends State<ModalCrearUsuario> {
  final _controller = UserController();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  bool _isActive = true;

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  // 🔹 Guardar usuario
  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (_name.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty ||
        _phone.text.isEmpty) {
      _mostrarMensaje("⚠️ Todos los campos son obligatorios", Colors.orange);
      return;
    }

    final creado = await _controller.crearUsuario({
      "name": _name.text.trim(),
      "email": _email.text.trim(),
      "password": _password.text.trim(),
      "phone": _phone.text.trim(),
      "is_active": _isActive,
      "role_id": 1, // Usuario normal
    });

    if (creado) {
      _mostrarMensaje("✅ Usuario creado correctamente", verde);
      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.pop(context);
        widget.onSuccess();
      });
    } else {
      _mostrarMensaje("❌ Error al crear usuario", Colors.redAccent);
    }
  }

  // 🔹 Mostrar mensaje con SnackBar
  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto, style: const TextStyle(fontSize: 15)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 520,
        padding: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),

        // 🔹 Contenido principal
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado verde
            Container(
              decoration: BoxDecoration(
                color: verde,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.person_add_alt_1_rounded,
                      color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Crear Nuevo Usuario",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),

            // Formulario
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _campoTexto(
                    label: "Nombre completo",
                    hint: "Ej: Juan Pérez",
                    icon: Icons.person_rounded,
                    controller: _name,
                  ),
                  const SizedBox(height: 18),
                  _campoTexto(
                    label: "Correo electrónico",
                    hint: "Ej: usuario@correo.com",
                    icon: Icons.email_outlined,
                    controller: _email,
                  ),
                  const SizedBox(height: 18),
                  _campoTexto(
                    label: "Contraseña",
                    hint: "Mínimo 6 caracteres",
                    icon: Icons.lock_outline,
                    controller: _password,
                    obscure: true,
                  ),
                  const SizedBox(height: 18),
                  _campoTexto(
                    label: "Teléfono",
                    hint: "Ej: 3128024988",
                    icon: Icons.phone_android_rounded,
                    controller: _phone,
                    teclado: TextInputType.phone,
                  ),
                  const SizedBox(height: 22),

                  // 🔹 Estado activo/inactivo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Estado del usuario:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      Row(
                        children: [
                          Switch(
                            value: _isActive,
                            activeColor: verde,
                            onChanged: (v) => setState(() => _isActive = v),
                          ),
                          Text(
                            _isActive ? "Activo" : "Inactivo",
                            style: TextStyle(
                              color: _isActive ? verdeOscuro : Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.black54, size: 20),
                        label: const Text("Cancelar",
                            style: TextStyle(color: Colors.black54)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _guardar,
                        icon: const Icon(Icons.save_rounded,
                            color: Colors.white, size: 22),
                        label: const Text(
                          "Guardar Usuario",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: verde,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 25),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget auxiliar para campos de texto
  Widget _campoTexto({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType teclado = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: teclado,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: verdeOscuro, size: 22),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: verde, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
