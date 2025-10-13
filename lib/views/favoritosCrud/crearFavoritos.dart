import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';

class ModalCrearFavorito extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearFavorito({super.key, required this.onSuccess});

  @override
  State<ModalCrearFavorito> createState() => _ModalCrearFavoritoState();
}

class _ModalCrearFavoritoState extends State<ModalCrearFavorito> {
  final FavoritesController _controller = Get.find<FavoritesController>();

  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _callCtrl = TextEditingController();

  bool _loading = false;

  Future<void> _guardar() async {
    if (_userCtrl.text.isEmpty || _callCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Todos los campos son obligatorios")),
      );
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.crearFavorite(
      int.parse(_userCtrl.text),
      int.parse(_callCtrl.text),
    );
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Favorito creado correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al crear favorito")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Agregar Favorito"),
      content: SizedBox(
        width: 400,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _userCtrl,
            decoration: const InputDecoration(labelText: "User ID"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _callCtrl,
            decoration: const InputDecoration(labelText: "Call ID"),
            keyboardType: TextInputType.number,
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: _loading ? null : _guardar,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF39A900)),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Guardar"),
        ),
      ],
    );
  }
}
