import 'package:app_bienestarmisena_v1/controllers/departamentoController.dart';
import 'package:app_bienestarmisena_v1/models/departamento/departamento.dart';
import 'package:app_bienestarmisena_v1/views/departamento/crearDepartamento.dart';
import 'package:app_bienestarmisena_v1/views/departamento/editarDepartamento.dart';
import 'package:flutter/material.dart';

class ViewDepartments extends StatefulWidget {
  const ViewDepartments({super.key});

  @override
  State<ViewDepartments> createState() => _ViewDepartmentsState();
}

class _ViewDepartmentsState extends State<ViewDepartments> {
  final DepartmentsController _controller = DepartmentsController();
  List<Department> _departments = [];
  List<Department> _filtered = [];
  bool _loading = true;
  String _search = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() => _loading = true);
    _departments = await _controller.getDepartments();
    _filtered = _departments;
    setState(() => _loading = false);
  }

  void _filter(String value) {
    setState(() {
      _search = value.toLowerCase();
      _filtered = _departments
          .where((d) => d.name.toLowerCase().contains(_search))
          .toList();
    });
  }

  Future<void> _deleteDepartment(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Eliminar Departamento?"),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Eliminar"),
          )
        ],
      ),
    );

    if (confirm == true) {
      final ok = await _controller.eliminarDepartment(id);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Departamento eliminado correctamente")),
        );
        _loadDepartments();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: 950,
        height: 700,
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Cabecera
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                "Gestión de Departamentos",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Administra los departamentos registrados",
                style: TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 30),

            // 🔍 Buscador + botón
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _filter,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Buscar departamento...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => ModalCrearDepartment(onSuccess: _loadDepartments),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Nuevo Departamento"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 🔹 Lista
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? const Center(child: Text("No hay departamentos registrados"))
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final d = _filtered[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 4,
                              child: ListTile(
                                title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("Creado el: ${d.createdAt.substring(0, 10)}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => ModalEditarDepartment(department: d, onSuccess: _loadDepartments),
                                        );
                                      },
                                      icon: Icon(Icons.edit, color: azul),
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteDepartment(d.id),
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
