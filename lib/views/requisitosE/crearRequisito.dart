import 'package:app_bienestarmisena_v1/controllers/requisitos_controller.dart' show RequirementsController;
import 'package:flutter/material.dart';

class ModalCrearRequirement extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearRequirement({super.key, required this.onSuccess});

  @override
  State<ModalCrearRequirement> createState() => _ModalCrearRequirementState();
}

class _ModalCrearRequirementState extends State<ModalCrearRequirement> {
  final RequirementsController _controller = RequirementsController();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();
  final TextEditingController _institutionCtrl = TextEditingController();
  final TextEditingController _groupCtrl = TextEditingController();

  bool _loading = false;

  Future<void> _guardar() async {
    if (_nameCtrl.text.isEmpty ||
        _notesCtrl.text.isEmpty ||
        _institutionCtrl.text.isEmpty ||
        _groupCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Todos los campos son obligatorios")),
      );
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.crearRequirement(
      _nameCtrl.text,
      _notesCtrl.text,
      int.parse(_institutionCtrl.text),
      int.parse(_groupCtrl.text),
    );
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Requisito creado correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al crear requisito")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nuevo Requisito"),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nombre")),
            const SizedBox(height: 10),
            TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: "Notas")),
            const SizedBox(height: 10),
            TextField(
                controller: _institutionCtrl,
                decoration: const InputDecoration(labelText: "Institution ID"),
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            TextField(
                controller: _groupCtrl,
                decoration: const InputDecoration(labelText: "Group ID"),
                keyboardType: TextInputType.number),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: _loading ? null : _guardar,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF39A900)),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Guardar"),
        ),
      ],
    );
  }
}
