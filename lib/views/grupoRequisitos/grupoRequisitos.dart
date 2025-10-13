import 'package:app_bienestarmisena_v1/controllers/requirementGruposController.dart';
import 'package:app_bienestarmisena_v1/models/grupoRequisitos/grupoRequisitos.dart';
import 'package:app_bienestarmisena_v1/views/grupoRequisitos/crearGrupoRequisitos.dart';
import 'package:app_bienestarmisena_v1/views/grupoRequisitos/editarGrupoRequisitos.dart';
import 'package:flutter/material.dart';

class ViewRequirementGroups extends StatefulWidget {
  const ViewRequirementGroups({super.key});

  @override
  State<ViewRequirementGroups> createState() => _ViewRequirementGroupsState();
}

class _ViewRequirementGroupsState extends State<ViewRequirementGroups> {
  final RequirementGroupsController _controller = RequirementGroupsController();
  List<RequirementGroup> _groups = [];
  List<RequirementGroup> _filtered = [];
  bool _loading = true;
  String _search = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() => _loading = true);
    try {
      _groups = await _controller.getRequirementGroups();
      _filtered = _groups;
    } catch (_) {}
    setState(() => _loading = false);
  }

  void _filter(String value) {
    setState(() {
      _search = value.toLowerCase();
      _filtered = _groups.where((g) {
        final catName = (g.category?['name'] ?? '').toString().toLowerCase();
        final reqText = (g.requirements ?? [])
            .map((r) => (r['name'] ?? '').toString().toLowerCase())
            .join(' ');
        return g.name.toLowerCase().contains(_search) ||
            catName.contains(_search) ||
            reqText.contains(_search);
      }).toList();
    });
  }

  Future<void> _deleteGroup(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("¿Eliminar grupo?"),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete, color: Colors.white, size: 18),
            label: const Text("Eliminar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final ok = await _controller.eliminarRequirementGroup(id);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🗑️ Grupo eliminado correctamente")),
        );
        _loadGroups();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Error al eliminar el grupo")),
        );
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
        width: 1000,
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
                "Grupos de Requisitos",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Administra los grupos, su categoría y requisitos asociados",
                style: TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 30),

            // 🔍 Buscador + botón
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: TextField(
                      onChanged: _filter,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 22),
                        hintText: "Buscar por nombre, categoría o requisito...",
                        hintStyle: const TextStyle(color: Colors.black38),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => ModalCrearRequirementGroup(onSuccess: _loadGroups),
                    );
                  },
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text("Nuevo Grupo",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
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
                      ? const Center(
                          child: Text("No se encontraron grupos.",
                              style: TextStyle(fontSize: 16, color: Colors.black54)))
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (context, i) {
                            final g = _filtered[i];
                            final catName = (g.category?['name'] ?? 'Sin categoría').toString();
                            final reqs = (g.requirements ?? []) as List<dynamic>;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F7EB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.folder_copy_rounded, color: verde, size: 28),
                                ),
                                title: Text(
                                  g.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6, right: 40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Categoría: $catName",
                                          style: const TextStyle(color: Colors.black54, fontSize: 13.5)),
                                      const SizedBox(height: 6),
                                      if (reqs.isNotEmpty) Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: reqs.take(5).map((r) {
                                          final label = (r['name'] ?? '').toString();
                                          return Chip(
                                            label: Text(label, style: const TextStyle(fontSize: 12)),
                                            backgroundColor: const Color(0xFFF3F6FF),
                                            side: const BorderSide(color: Color(0xFFE0E6FF)),
                                          );
                                        }).toList(),
                                      ) else
                                        const Text("Sin requisitos asociados",
                                            style: TextStyle(color: Colors.black38, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: "Editar",
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF2FF),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(Icons.edit, color: azul, size: 20),
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => ModalEditarRequirementGroup(
                                            group: g,
                                            onSuccess: _loadGroups,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      tooltip: "Eliminar",
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFECEC),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                      ),
                                      onPressed: () => _deleteGroup(g.id),
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
