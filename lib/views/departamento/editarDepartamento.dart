import 'package:app_bienestarmisena_v1/controllers/departamento/departamento_controller.dart';
import 'package:app_bienestarmisena_v1/models/departamento/departamento.dart';
import 'package:flutter/material.dart';

class ModalEditarDepartment extends StatefulWidget {
  final Department department;
  final VoidCallback onSuccess;

  const ModalEditarDepartment({super.key, required this.department, required this.onSuccess});

  @override
  State<ModalEditarDepartment> createState() => _ModalEditarDepartmentState();
}

class _ModalEditarDepartmentState extends State<ModalEditarDepartment> {
  final DepartmentsController _controller = DepartmentsController();
  late TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.department.name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Departamento"),
      content: TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nombre")),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: () async {
            final ok = await _controller.editarDepartment(widget.department.id, _nameCtrl.text);
            if (ok) {
              widget.onSuccess();
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0075FF)),
          child: const Text("Actualizar"),
        ),
      ],
    );
  }
}
