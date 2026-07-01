import 'package:app_bienestarmisena_v1/models/requirement_categoryModel/requirement_category.dart';
import 'package:app_bienestarmisena_v1/views/RequirementCategory/crearRequirementCategory.dart';
import 'package:app_bienestarmisena_v1/views/RequirementCategory/editarRequirementCategory.dart';
import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/controllers/requisitos/requirement_category_controller.dart';

class ViewRequirementCategories extends StatefulWidget {
  const ViewRequirementCategories({super.key});

  @override
  State<ViewRequirementCategories> createState() => _ViewRequirementCategoriesState();
}

class _ViewRequirementCategoriesState extends State<ViewRequirementCategories> {
  final RequirementCategoriesController _controller = RequirementCategoriesController();

  List<RequirementCategory> _items = [];
  List<RequirementCategory> _filtered = [];
  bool _loading = true;
  String _search = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul  = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    setState(() => _loading = true);
    try {
      _items = await _controller.getRequirementCategories();
      _filtered = _items;
    } catch (_) {
      _mostrarSnack("❌ Error al cargar las categorías", Colors.redAccent);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _filtrar(String value) {
    setState(() {
      _search = value.toLowerCase();
      _filtered = _items.where((e) => e.name.toLowerCase().contains(_search)).toList();
    });
  }

  void _mostrarSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 15)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _eliminarCategoria(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("¿Eliminar categoría?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar", style: TextStyle(color: Colors.black54)),
          ),
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

    if (confirmar == true) {
      final ok = await _controller.eliminarRequirementCategory(id);
      if (ok) {
        _mostrarSnack("🗑️ Categoría eliminada", verde);
        _cargarCategorias();
      } else {
        _mostrarSnack("❌ Error al eliminar", Colors.redAccent);
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Cabecera con degradado
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                "Gestión de Categorías de Requisitos",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Administra las categorías utilizadas para clasificar requisitos",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 30),

            // 🔍 Buscador + botón crear
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: _filtrar,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 22),
                        hintText: "Buscar categorías...",
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
                      builder: (_) => ModalCrearRequirementCategory(onSuccess: _cargarCategorias),
                    );
                  },
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text("Nueva Categoría",
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
                          child: Text("No se encontraron categorías.",
                              style: TextStyle(fontSize: 16, color: Colors.black54)))
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (context, i) {
                            final item = _filtered[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F7EB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.category_outlined, color: verde, size: 28),
                                ),
                                title: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5, right: 40),
                                  child: Text(
                                    "ID: ${item.id} • Actualizado: ${item.updatedAt}",
                                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => ModalEditarRequirementCategory(
                                            item: item,
                                            onSuccess: _cargarCategorias,
                                          ),
                                        );
                                      },
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF2FF),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(Icons.edit, color: azul, size: 20),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      onPressed: () => _eliminarCategoria(item.id),
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFECEC),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                      ),
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
