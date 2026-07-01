import 'package:app_bienestarmisena_v1/controllers/departamento/departamento_controller.dart';
import 'package:flutter/material.dart';

class ModalCrearDepartment extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearDepartment({super.key, required this.onSuccess});

  @override
  State<ModalCrearDepartment> createState() => _ModalCrearDepartmentState();
}

class _ModalCrearDepartmentState extends State<ModalCrearDepartment> {
  final TextEditingController _nameCtrl = TextEditingController();
  final DepartmentsController _controller = DepartmentsController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nuevo Departamento"),
      content: TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nombre")),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: () async {
            final ok = await _controller.crearDepartment(_nameCtrl.text);
            if (ok) {
              widget.onSuccess();
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF39A900)),
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
