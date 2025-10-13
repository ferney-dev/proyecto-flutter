import 'package:app_bienestarmisena_v1/controllers/rol_controller.dart';
import 'package:app_bienestarmisena_v1/models/rol/rol.dart';
import 'package:flutter/material.dart';

class ModalEditarRol extends StatefulWidget {
  final Rol rol;
  final VoidCallback onSuccess;
  const ModalEditarRol({super.key, required this.rol, required this.onSuccess});

  @override
  State<ModalEditarRol> createState() => _ModalEditarRolState();
}

class _ModalEditarRolState extends State<ModalEditarRol> {
  final RolesController _controller = RolesController();
  late TextEditingController _nombre;

  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.rol.name);
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (_nombre.text.isEmpty) {
      _mostrarMensaje("⚠️ El nombre es obligatorio", Colors.orange);
      return;
    }

    final editado = await _controller.editarRol(widget.rol.id, {
      "name": _nombre.text.trim(),
    });

    if (editado) {
      _mostrarMensaje("✅ Rol actualizado correctamente", Colors.green);
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      _mostrarMensaje("❌ Error al actualizar rol", Colors.redAccent);
    }
  }

  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(texto), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 150, vertical: 100),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: azul,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Center(
                child: Text(
                  "Editar Rol",
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
                    const Icon(Icons.edit, color: Color(0xFF0075FF), size: 22),
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
              label: const Text("Guardar Cambios",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: azul,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12)),
            )
          ],
        ),
      ),
    );
  }
}
