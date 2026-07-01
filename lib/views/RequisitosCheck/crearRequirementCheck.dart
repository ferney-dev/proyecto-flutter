import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/controllers/requisitos/requirement_check_controller.dart';

class ModalCrearRequirementCheck extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearRequirementCheck({super.key, required this.onSuccess});

  @override
  State<ModalCrearRequirementCheck> createState() => _ModalCrearRequirementCheckState();
}

class _ModalCrearRequirementCheckState extends State<ModalCrearRequirementCheck> {
  final RequirementChecksController _controller = RequirementChecksController();
  final TextEditingController _nameCtrl = TextEditingController();

  bool _loading = false;

  // ======================================================
  // 🔹 GUARDAR NUEVO REQUIREMENT CHECK
  // ======================================================
  Future<void> _guardar() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ El nombre no puede estar vacío")),
      );
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.crearRequirementCheck(_nameCtrl.text.trim());
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Registro creado correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al crear el registro")),
      );
    }
  }

  // ======================================================
  // 🔹 UI DEL MODAL
  // ======================================================
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.add_circle_outline, color: Color(0xFF39A900)),
          SizedBox(width: 8),
          Text("Nuevo Requirement Check"),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "Nombre",
                prefixIcon: const Icon(Icons.assignment_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", style: TextStyle(color: Colors.black54)),
        ),
        ElevatedButton.icon(
          onPressed: _loading ? null : _guardar,
          icon: _loading
              ? const SizedBox(
                  width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save, size: 20),
          label: const Text("Guardar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF39A900),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
