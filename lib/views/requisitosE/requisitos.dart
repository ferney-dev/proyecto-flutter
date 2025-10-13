import 'package:app_bienestarmisena_v1/controllers/requisitos_controller.dart';
import 'package:app_bienestarmisena_v1/models/requisitosModel/requisitos.dart';
import 'package:app_bienestarmisena_v1/views/requisitosE/crearRequisito.dart';
import 'package:app_bienestarmisena_v1/views/requisitosE/editarRequisito.dart';
import 'package:flutter/material.dart';

class ViewRequirements extends StatefulWidget {
  const ViewRequirements({super.key});

  @override
  State<ViewRequirements> createState() => _ViewRequirementsState();
}

class _ViewRequirementsState extends State<ViewRequirements> {
  final RequirementsController _controller = RequirementsController();
  List<Requirement> _items = [];
  List<Requirement> _filtered = [];
  bool _loading = true;
  String _search = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _items = await _controller.getRequirements();
    _filtered = _items;
    setState(() => _loading = false);
  }

  void _filter(String value) {
    setState(() {
      _search = value.toLowerCase();
      _filtered = _items.where((e) {
        final inst = (e.institution?['name'] ?? '').toString().toLowerCase();
        final group = (e.requirementGroup?['name'] ?? '').toString().toLowerCase();
        return e.name.toLowerCase().contains(_search) ||
            inst.contains(_search) ||
            group.contains(_search);
      }).toList();
    });
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Eliminar requisito?"),
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
      final ok = await _controller.eliminarRequirement(id);
      if (ok) {
        _load();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("🗑️ Eliminado correctamente")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      child: Container(
        width: 1000,
        height: 700,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            const Text("Gestión de Requisitos",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _filter,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Buscar por nombre, institución o grupo...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (_) => ModalCrearRequirement(onSuccess: _load));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Nuevo requisito"),
                  style: ElevatedButton.styleFrom(backgroundColor: verde),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? const Center(child: Text("No hay registros"))
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final r = _filtered[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(r.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    "Institución: ${r.institution?['name'] ?? 'N/A'}\nGrupo: ${r.requirementGroup?['name'] ?? 'N/A'}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => ModalEditarRequirement(
                                              item: r, onSuccess: _load),
                                        );
                                      },
                                      icon: Icon(Icons.edit, color: azul),
                                    ),
                                    IconButton(
                                      onPressed: () => _delete(r.id),
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent),
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
