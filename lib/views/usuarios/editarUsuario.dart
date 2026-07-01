import 'package:app_bienestarmisena_v1/controllers/usuario/usuario_controller.dart';
import 'package:app_bienestarmisena_v1/models/usuarioModel/usuariosModel.dart';
import 'package:flutter/material.dart';

class ModalEditarUsuario extends StatefulWidget {
  final UserModel usuario;
  final VoidCallback onSuccess;
  const ModalEditarUsuario({
    super.key,
    required this.usuario,
    required this.onSuccess,
  });

  @override
  State<ModalEditarUsuario> createState() => _ModalEditarUsuarioState();
}

class _ModalEditarUsuarioState extends State<ModalEditarUsuario> {
  final _controller = UserController();

  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _phone;
  late TextEditingController _img;
  bool _isActive = true;

  final Color azul = const Color(0xFF0075FF);
  final Color azulOscuro = const Color(0xFF004CB3);

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.usuario.name);
    _email = TextEditingController(text: widget.usuario.email);
    _phone = TextEditingController(text: widget.usuario.phone ?? '');
    _img = TextEditingController(text: widget.usuario.imgUser ?? '');
    _isActive = widget.usuario.isActive ?? true;
  }

  // 🔹 Actualizar usuario
  Future<void> _actualizar() async {
    FocusScope.of(context).unfocus();

    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) {
      _mostrarMensaje("⚠️ El nombre y el correo son obligatorios", Colors.orange);
      return;
    }

    final actualizado = await _controller.editarUsuario(widget.usuario.id, {
      "name": _name.text.trim(),
      "email": _email.text.trim(),
      "phone": _phone.text.trim(),
      "imgUser": _img.text.trim(),
      "is_active": _isActive,
    });

    if (actualizado) {
      _mostrarMensaje("✅ Usuario actualizado correctamente", azul);
      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.pop(context);
        widget.onSuccess();
      });
    } else {
      _mostrarMensaje("❌ Error al actualizar el usuario", Colors.redAccent);
    }
  }

  // 🔹 Mostrar mensaje tipo SnackBar
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
            // 🔹 Encabezado azul
            Container(
              decoration: BoxDecoration(
                color: azul,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.edit_rounded,
                      color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Editar Usuario",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),

            // 🔹 Formulario
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _campoTexto(
                    label: "Nombre completo",
                    hint: "Ej: Juan Pérez",
                    icon: Icons.person_outline,
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
                    label: "Teléfono",
                    hint: "Ej: 3128024988",
                    icon: Icons.phone_android_rounded,
                    controller: _phone,
                    teclado: TextInputType.phone,
                  ),
                  const SizedBox(height: 18),
                  _campoTexto(
                    label: "URL de imagen (opcional)",
                    hint: "Ej: https://foto-perfil.com/imagen.jpg",
                    icon: Icons.image_outlined,
                    controller: _img,
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
                            activeColor: azul,
                            onChanged: (v) => setState(() => _isActive = v),
                          ),
                          Text(
                            _isActive ? "Activo" : "Inactivo",
                            style: TextStyle(
                              color: _isActive
                                  ? azulOscuro
                                  : Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Botones
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
                        onPressed: _actualizar,
                        icon: const Icon(Icons.save_as_rounded,
                            color: Colors.white, size: 22),
                        label: const Text(
                          "Guardar Cambios",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azul,
                          foregroundColor: Colors.white,
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

  // 🔹 Widget reutilizable para campos de texto
  Widget _campoTexto({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
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
          keyboardType: teclado,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: azulOscuro, size: 22),
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
              borderSide: BorderSide(color: azul, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
