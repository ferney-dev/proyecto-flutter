import 'package:app_bienestarmisena_v1/controllers/ciudad/ciudad_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/departamento/departamento_controller.dart';
import 'package:app_bienestarmisena_v1/models/cuidad/cuidad.dart' hide Department;
import 'package:app_bienestarmisena_v1/models/departamento/departamento.dart';

import 'package:flutter/material.dart';

class ModalEditarCity extends StatefulWidget {
  final City city;
  final VoidCallback onSuccess;
  const ModalEditarCity({super.key, required this.city, required this.onSuccess});

  @override
  State<ModalEditarCity> createState() => _ModalEditarCityState();
}

class _ModalEditarCityState extends State<ModalEditarCity> {
  final CitiesController _controller = CitiesController();
  final DepartmentsController _deptController = DepartmentsController();
  late TextEditingController _nameCtrl;

  List<Department> _departments = [];
  int? _selectedDept;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.city.name);
    _selectedDept = widget.city.departmentId;
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final data = await _deptController.getDepartments();
    setState(() => _departments = data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Ciudad"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nombre")),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: _selectedDept,
            decoration: const InputDecoration(labelText: "Departamento"),
            items: _departments
                .map((d) => DropdownMenuItem(value: d.id, child: Text(d.name)))
                .toList(),
            onChanged: (v) => setState(() => _selectedDept = v),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: () async {
            if (_selectedDept != null) {
              final ok = await _controller.editarCity(widget.city.id, _nameCtrl.text, _selectedDept!);
              if (ok) {
                widget.onSuccess();
                Navigator.pop(context);
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0075FF)),
          child: const Text("Actualizar"),
        ),
      ],
    );
  }
}
