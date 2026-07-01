import 'package:app_bienestarmisena_v1/models/requirement_categoryModel/requirement_category.dart';
import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/controllers/requisitos/requirement_category_controller.dart';

class ModalEditarRequirementCategory extends StatefulWidget {
  final RequirementCategory item;
  final VoidCallback onSuccess;
  const ModalEditarRequirementCategory(
      {super.key, required this.item, required this.onSuccess});

  @override
  State<ModalEditarRequirementCategory> createState() =>
      _ModalEditarRequirementCategoryState();
}

class _ModalEditarRequirementCategoryState
    extends State<ModalEditarRequirementCategory> {
  final RequirementCategoriesController _controller =
      RequirementCategoriesController();
  late TextEditingController _nameCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item.name);
  }

  Future<void> _actualizar() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ El nombre no puede estar vacío")),
      );
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.editarRequirementCategory(
        widget.item.id, _nameCtrl.text.trim());
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Categoría actualizada correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al actualizar la categoría")),
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
          Text("Editar Categoría"),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: _nameCtrl,
          decoration: InputDecoration(
            labelText: "Nombre",
            prefixIcon: const Icon(Icons.category_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", style: TextStyle(color: Colors.black54)),
        ),
        ElevatedButton.icon(
          onPressed: _loading ? null : _actualizar,
          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save, size: 20),
          label: const Text("Actualizar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0075FF),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
