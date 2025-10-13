import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/controllers/lineas_controller.dart';

class ModalCrearLinea extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearLinea({super.key, required this.onSuccess});

  @override
  State<ModalCrearLinea> createState() => _ModalCrearLineaState();
}

class _ModalCrearLineaState extends State<ModalCrearLinea> {
  final LineasController _controller = LineasController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus(); // cerrar teclado

    if (_name.text.trim().isEmpty) {
      _mostrarMensaje("⚠️ El nombre de la línea es obligatorio", Colors.orange);
      return;
    }

    final bool creada = await _controller.crearLinea({
      "name": _name.text.trim(),
      "description": _desc.text.trim(),
    });

    if (creada) {
      _mostrarMensaje("✅ Línea creada correctamente", verde);
      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.pop(context);
        widget.onSuccess();
      });
    } else {
      _mostrarMensaje("❌ Error al crear la línea. Verifica el servidor.", Colors.redAccent);
    }
  }

  // 🔹 Función auxiliar para mostrar SnackBar
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
            // 🔹 Encabezado
            Container(
              decoration: BoxDecoration(
                color: verde,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.share_rounded,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Crear Nueva Línea",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 26),
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
                  const Text(
                    "Nombre de la Línea",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _name,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.timeline_rounded,
                          color: verdeOscuro, size: 26),
                      hintText: "Ej: Tecnología, Educación, Innovación...",
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: verde, width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Descripción",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _desc,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.notes_rounded,
                          color: verdeOscuro, size: 26),
                      hintText: "Describa brevemente la línea de trabajo",
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: verde, width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.black54, size: 22),
                        label: const Text("Cancelar",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 15)),
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
                            color: Colors.white, size: 24),
                        label: const Text(
                          "Guardar Línea",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: verde,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 25),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
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
