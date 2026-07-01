import 'package:app_bienestarmisena_v1/controllers/requisitos/requisitos_controller.dart';
import 'package:app_bienestarmisena_v1/models/requisitosModel/requisitos.dart';
import 'package:flutter/material.dart';

class ModalEditarRequirement extends StatefulWidget {
  final Requirement item;
  final VoidCallback onSuccess;
  const ModalEditarRequirement({super.key, required this.item, required this.onSuccess});

  @override
  State<ModalEditarRequirement> createState() => _ModalEditarRequirementState();
}

class _ModalEditarRequirementState extends State<ModalEditarRequirement> {
  final RequirementsController _controller = RequirementsController();

  late TextEditingController _nameCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _institutionCtrl;
  late TextEditingController _groupCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item.name);
    _notesCtrl = TextEditingController(text: widget.item.notes);
    _institutionCtrl = TextEditingController(text: widget.item.institutionId.toString());
    _groupCtrl = TextEditingController(text: widget.item.groupId.toString());
  }

  Future<void> _actualizar() async {
    if (_nameCtrl.text.isEmpty || _notesCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("⚠️ Todos los campos son obligatorios")));
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.editarRequirement(
      widget.item.id,
      _nameCtrl.text,
      _notesCtrl.text,
      int.parse(_institutionCtrl.text),
      int.parse(_groupCtrl.text),
    );
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("✅ Requisito actualizado")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("❌ Error al actualizar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Requisito"),
      content: SizedBox(
        width: 400,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: _loading ? null : _actualizar,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0075FF)),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Actualizar"),
        ),
      ],
    );
  }
}
