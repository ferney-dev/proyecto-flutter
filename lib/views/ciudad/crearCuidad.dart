import 'package:app_bienestarmisena_v1/controllers/ciudad/ciudad_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/departamento/departamento_controller.dart';
import 'package:app_bienestarmisena_v1/models/departamento/departamento.dart';
import 'package:flutter/material.dart';

class ModalCrearCity extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearCity({super.key, required this.onSuccess});

  @override
  State<ModalCrearCity> createState() => _ModalCrearCityState();
}

class _ModalCrearCityState extends State<ModalCrearCity> {
  final TextEditingController _nameCtrl = TextEditingController();
  final CitiesController _controller = CitiesController();
  final DepartmentsController _deptController = DepartmentsController();

  List<Department> _departments = [];
  int? _selectedDept;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final data = await _deptController.getDepartments();
    setState(() => _departments = data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nueva Ciudad"),
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
            if (_selectedDept != null && _nameCtrl.text.isNotEmpty) {
              final ok = await _controller.crearCity(_nameCtrl.text, _selectedDept!);
              if (ok) {
                widget.onSuccess();
                Navigator.pop(context);
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF39A900)),
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
