import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/controllers/lineas/lineas_controller.dart';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';

class ModalEditarLinea extends StatefulWidget {
  final Linea linea;
  final VoidCallback onSuccess;
  const ModalEditarLinea({
    super.key,
    required this.linea,
    required this.onSuccess,
  });

  @override
  State<ModalEditarLinea> createState() => _ModalEditarLineaState();
}

class _ModalEditarLineaState extends State<ModalEditarLinea> {
  final LineasController _controller = LineasController();
  late TextEditingController _name;
  late TextEditingController _desc;

  final Color azul = const Color(0xFF0075FF);
  final Color azulOscuro = const Color(0xFF004CB3);

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.linea.name);
    _desc = TextEditingController(text: widget.linea.description ?? '');
  }

  Future<void> _actualizar() async {
    FocusScope.of(context).unfocus(); // cerrar teclado

    if (_name.text.trim().isEmpty) {
      _mostrarMensaje("⚠️ El nombre de la línea es obligatorio", Colors.orange);
      return;
    }

    final bool editada = await _controller.editarLinea(widget.linea.id, {
      "name": _name.text.trim(),
      "description": _desc.text.trim(),
    });

    if (editada) {
      _mostrarMensaje("✅ Línea actualizada correctamente", azul);
      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.pop(context);
        widget.onSuccess();
      });
    } else {
      _mostrarMensaje("❌ Error al actualizar la línea. Verifica el servidor.", Colors.redAccent);
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
                  const Icon(Icons.edit_note_rounded,
                      color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Editar Línea",
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

            // 🔹 Formulario
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo Nombre
                  const Text(
                    "Nombre de la Línea",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.timeline, color: azulOscuro, size: 22),
                      hintText: "Ej: Tecnología, Educación, etc.",
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: azul, width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Campo Descripción
                  const Text(
                    "Descripción",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _desc,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.notes_rounded,
                          color: azulOscuro, size: 22),
                      hintText: "Actualice o describa la línea",
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: azul, width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cancelar
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

                      // Actualizar
                      ElevatedButton.icon(
                        onPressed: _actualizar,
                        icon: const Icon(Icons.save_as_rounded,
                            color: Colors.white, size: 22),
                        label: const Text(
                          "Actualizar Línea",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
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
}
