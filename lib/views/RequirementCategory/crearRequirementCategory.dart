import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/controllers/requirement_category_controller.dart';

class ModalCrearRequirementCategory extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearRequirementCategory({super.key, required this.onSuccess});

  @override
  State<ModalCrearRequirementCategory> createState() =>
      _ModalCrearRequirementCategoryState();
}

class _ModalCrearRequirementCategoryState
    extends State<ModalCrearRequirementCategory> {
  final RequirementCategoriesController _controller =
      RequirementCategoriesController();
  final TextEditingController _nameCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _guardar() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ El nombre no puede estar vacío")),
      );
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.crearRequirementCategory(_nameCtrl.text.trim());
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Categoría creada correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al crear la categoría")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.add_circle_outline, color: Color(0xFF39A900)),
          SizedBox(width: 8),
          Text("Nueva Categoría"),
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
          onPressed: _loading ? null : _guardar,
          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save, size: 20),
          label: const Text("Guardar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF39A900),
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
