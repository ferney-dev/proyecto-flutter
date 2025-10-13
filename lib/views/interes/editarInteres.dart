import 'package:app_bienestarmisena_v1/controllers/interesController.dart';
import 'package:app_bienestarmisena_v1/models/interes/interes_model.dart';
import 'package:flutter/material.dart';

class ModalEditarInteres extends StatefulWidget {
  final Interes interes;
  final VoidCallback onSuccess;

  const ModalEditarInteres({
    super.key,
    required this.interes,
    required this.onSuccess,
  });

  @override
  State<ModalEditarInteres> createState() => _ModalEditarInteresState();
}

class _ModalEditarInteresState extends State<ModalEditarInteres> {
  final _controller = InteresController();

  late TextEditingController _name;
  late TextEditingController _description;

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.interes.name);
    _description = TextEditingController(text: widget.interes.description);
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (_name.text.isEmpty || _description.text.isEmpty) {
      _mostrarMensaje("⚠️ Todos los campos son obligatorios", Colors.orange);
      return;
    }

    final editado = await _controller.editarInteres(widget.interes.id, {
      "name": _name.text.trim(),
      "description": _description.text.trim(),
    });

    if (editado) {
      _mostrarMensaje("✅ Interés actualizado correctamente", verde);
      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.pop(context);
        widget.onSuccess();
      });
    } else {
      _mostrarMensaje("❌ Error al actualizar interés", Colors.redAccent);
    }
  }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Encabezado azul
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0075FF),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.edit_note_rounded,
                      color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Editar Interés",
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
                    label: "Nombre del interés",
                    hint: "Ej: Innovación y tecnología",
                    icon: Icons.interests_rounded,
                    controller: _name,
                  ),
                  const SizedBox(height: 18),
                  _campoTexto(
                    label: "Descripción",
                    hint: "Breve descripción del interés...",
                    icon: Icons.description_outlined,
                    controller: _description,
                    maxLines: 5,
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
                        onPressed: _guardar,
                        icon: const Icon(Icons.save_rounded,
                            color: Colors.white, size: 22),
                        label: const Text(
                          "Guardar Cambios",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0075FF),
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

  // 🔹 Campo de texto reutilizable
  Widget _campoTexto({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
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
