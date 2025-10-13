import 'package:app_bienestarmisena_v1/models/requerimientosChequeos/requirement_check.dart';
import 'package:app_bienestarmisena_v1/views/RequisitosCheck/crearRequirementCheck.dart';
import 'package:app_bienestarmisena_v1/views/RequisitosCheck/editarRequirementCheck.dart';
import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/controllers/requirement_check_controller.dart';

class ViewRequirementChecks extends StatefulWidget {
  const ViewRequirementChecks({super.key});

  @override
  State<ViewRequirementChecks> createState() => _ViewRequirementChecksState();
}

class _ViewRequirementChecksState extends State<ViewRequirementChecks> {
  final RequirementChecksController _controller = RequirementChecksController();
  List<RequirementCheck> _items = [];
  List<RequirementCheck> _filtered = [];
  bool _loading = true;
  String _search = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _loading = true);
    _items = await _controller.getRequirementChecks();
    _filtered = _items;
    setState(() => _loading = false);
  }

  void _filter(String value) {
    setState(() {
      _search = value.toLowerCase();
      _filtered = _items.where((i) => i.name.toLowerCase().contains(_search)).toList();
    });
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Eliminar registro?"),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final ok = await _controller.eliminarRequirementCheck(id);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Eliminado correctamente")),
        );
        _loadItems();
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
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
              ).createShader(bounds),
              child: const Text(
                "Gestión de Requirement Checks",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Administra los requerimientos verificados",
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
                      hintText: "Buscar...",
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
                      builder: (_) => ModalCrearRequirementCheck(onSuccess: _loadItems),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Nuevo Registro"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? const Center(child: Text("No hay registros disponibles"))
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final item = _filtered[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 4,
                              child: ListTile(
                                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("ID: ${item.id}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => ModalEditarRequirementCheck(
                                            item: item,
                                            onSuccess: _loadItems,
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit, color: azul),
                                    ),
                                    IconButton(
                                      onPressed: () => _delete(item.id),
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
