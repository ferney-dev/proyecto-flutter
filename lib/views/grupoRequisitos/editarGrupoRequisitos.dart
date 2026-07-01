import 'package:app_bienestarmisena_v1/controllers/requisitos/requirement_grupos_controller.dart';
import 'package:app_bienestarmisena_v1/models/grupoRequisitos/grupoRequisitos.dart';
import 'package:app_bienestarmisena_v1/models/requirement_categoryModel/requirement_category.dart';
import 'package:flutter/material.dart';

import 'package:app_bienestarmisena_v1/controllers/requisitos/requirement_category_controller.dart';

class ModalEditarRequirementGroup extends StatefulWidget {
  final RequirementGroup group;
  final VoidCallback onSuccess;
  const ModalEditarRequirementGroup({super.key, required this.group, required this.onSuccess});

  @override
  State<ModalEditarRequirementGroup> createState() => _ModalEditarRequirementGroupState();
}

class _ModalEditarRequirementGroupState extends State<ModalEditarRequirementGroup> {
  final RequirementGroupsController _controller = RequirementGroupsController();
  final RequirementCategoriesController _catController = RequirementCategoriesController();

  late TextEditingController _nameCtrl;
  int? _selectedCategory;
  List<RequirementCategory> _categories = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.group.name);
    _selectedCategory = widget.group.categoryId;
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    _categories = await _catController.getRequirementCategories();
    setState(() {});
  }

  Future<void> _actualizar() async {
    if (_nameCtrl.text.trim().isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Todos los campos son obligatorios")),
      );
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.editarRequirementGroup(widget.group.id, _nameCtrl.text.trim(), _selectedCategory!);
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Grupo actualizado correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al actualizar grupo")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.edit, color: Color(0xFF0075FF)),
          SizedBox(width: 8),
          Text("Editar Grupo de Requisitos"),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "Nombre del grupo",
                prefixIcon: const Icon(Icons.folder_open_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<int>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: "Categoría",
                prefixIcon: const Icon(Icons.category_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _categories.map((e) {
                return DropdownMenuItem<int>(
                  value: e.id,
                  child: Text(e.name),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton.icon(
          onPressed: _loading ? null : _actualizar,
          icon: _loading
              ? const SizedBox(
                  width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save),
          label: const Text("Actualizar"),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0075FF)),
        ),
      ],
    );
  }
}
