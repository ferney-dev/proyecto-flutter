import 'package:app_bienestarmisena_v1/controllers/rol/rol_controller.dart';
import 'package:flutter/material.dart';

class ModalCrearRol extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearRol({super.key, required this.onSuccess});

  @override
  State<ModalCrearRol> createState() => _ModalCrearRolState();
}

class _ModalCrearRolState extends State<ModalCrearRol> {
  final RolesController _controller = RolesController();
  final TextEditingController _nombre = TextEditingController();

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();
    if (_nombre.text.isEmpty) {
      _mostrarMensaje("⚠️ El nombre del rol es obligatorio", Colors.orange);
      return;
    }

    final creado = await _controller.crearRol({"name": _nombre.text.trim()});
    if (creado) {
      _mostrarMensaje("✅ Rol creado correctamente", verde);
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      _mostrarMensaje("❌ Error al crear rol", Colors.redAccent);
    }
  }

  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      backgroundColor: color,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 150, vertical: 100),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: verde,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Center(
                child: Text(
                  "Crear Rol",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _nombre,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.person_outline, color: verdeOscuro, size: 22),
                labelText: "Nombre del Rol",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text("Guardar",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12)),
            )
          ],
        ),
      ),
    );
  }
}
